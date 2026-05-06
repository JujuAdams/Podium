/// @param oldSignIn

function __PodiumSwitchTryCompleteLogin(_oldSignedIn)
{
    //Submit all pending local scores if we're newly signed in
    if ((not _oldSignedIn) && PodiumGetUserSignedIn())
    {
        with(__PodiumSystem())
        {
            if (__switchNickname != "")
            {
                if (PODIUM_VERBOSE)
                {
                    __PodiumTrace($"Set Switch nickname to {__switchNickname}");
                }
                
                switch_npln_leaderboard_set_user_data(__switchNPLNUserHandle, __switchNickname);
            }
        }
        
        __PodiumClearAllCaches();
        __PodiumLocalSubmitAllPending();
    }
}