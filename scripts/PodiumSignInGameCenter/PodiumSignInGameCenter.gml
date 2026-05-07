function PodiumSignInGameCenter()
{
    static _system = __PodiumSystem();
    
    if (PODIUM_USING_GAMECENTER)
    {
        with(_system)
        {
            if (__signInState == PODIUM_USER_SIGNING_IN)
            {
                __PodiumSoftError("Cannot sign in a new GameCenter user, a user is already signing in");
                return;
            }
            
            if (__signInState == PODIUM_USER_SIGNED_IN)
            {
                __PodiumWarning("GameCenter user is already signed in");
                return;
            }
            
            __PodiumGlobalClearRemoteCaches();
            
            __signInState = PODIUM_USER_SIGNING_IN;
            
            GameCenter_LocalPlayer_Authenticate();
        }
    }
}