/// @param xboxUser

function PodiumSignInXbox(_xboxUser = 0)
{
    static _system = __PodiumSystem();
    
    if (PODIUM_USING_GDK)
    {
        with(_system)
        {
            if (__signInState == PODIUM_USER_SIGNING_IN)
            {
                __PodiumSoftError("Cannot sign in a new Xbox user, a user is already signing in");
                return;
            }
            
            __xboxUser = int64(_xboxUser);
            __username = (_xboxUser < 0)? "" : xboxone_modern_gamertag_for_user(_xboxUser);
            
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Set Xbox user to {_xboxUser} \"{__username}\"");
            }
            
            __PodiumGlobalClearRemoteCaches();
            
            if (_xboxUser <= 0)
            {
                __signInState = PODIUM_USER_SIGNED_OUT;
                return;
            }
            
            __signInState = PODIUM_USER_SIGNING_IN;
            
            if (PODIUM_USING_XBOX_LEADERBOARDS)
            {
                xboxone_stats_setup(undefined, undefined, undefined); //TODO - Is this needed any more?
                xboxone_stats_add_user(_xboxUser);
                
                call_later(1, time_source_units_frames, function()
                {
                    __PodiumUserSignedIn();
                });
            }
            else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
            {
                __playFabLoggedIn = false;
                __PodiumPlayFabXboxRequestToken();
            }
            
            __PodiumSubmitAllPendingOfflineRecords();
        }
    }
}