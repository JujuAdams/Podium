/// Sets the user that has unlocked an achievement. You should call this function at least once
/// before calling `PodiumAward()`.
/// 
/// @param xboxUser

function PodiumSetXboxUser(_xboxUser)
{
    static _system = __PodiumSystem();
    
    if (PODIUM_USING_GDK)
    {
        if (_system.__xboxUser != _xboxUser)
        {
            _system.__xboxUser = int64(_xboxUser);
            
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Set Xbox user to {_xboxUser}");
            }
            
            if (_xboxUser > 0)
            {
                _system.__xboxModernGamertag = xboxone_modern_gamertag_for_user(_xboxUser);
                
                if (PODIUM_USING_XBOX_LEADERBOARDS)
                {
                    xboxone_stats_setup(undefined, undefined, undefined); //TODO
                    xboxone_stats_add_user(_xboxUser);
                }
                else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
                {
                    //FIXME - It's possible for tokens to get confused if you set the Xbox user rapidly
                    
                    _system.__playFabLoggedIn = false;
                    
                    __PodiumPlayFabXboxRequestToken();
                }
            }
            
            __PodiumClearAllCaches();
            __PodiumLocalSubmitAllPending();
        }
    }
}