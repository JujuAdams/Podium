function PodiumSignInGooglePlay()
{
    static _system = __PodiumSystem();
    
    if (PODIUM_USING_PLAY_SERVICES)
    {
        with(_system)
        {
            if (__signInState == PODIUM_USER_SIGNING_IN)
            {
                __PodiumSoftError("Cannot sign in a new Google Play user, a user is already signing in");
                return;
            }
            
            if (__signInState == PODIUM_USER_SIGNED_IN)
            {
                __PodiumWarning("Google Play user is already signed in");
                return;
            }
            
            __PodiumGlobalClearRemoteCaches();
            
            __signInState = PODIUM_USER_SIGNING_IN;
            
            GooglePlayServices_SignIn();
        }
    }
}