function __PodiumUserSignedIn()
{
    static _system = __PodiumSystem();
    with(_system)
    {
        __PodiumTrace("User signed in");
        __signInState = PODIUM_USER_SIGNED_IN;
    
        if (__initialized)
        {
            __PodiumGlobalClearRemoteCaches();
            __PodiumSubmitAllPendingOfflineRecords();
        }
        else
        {
            __PodiumWarning("User signed in before Podium was initialized");
            __signedInWhilstUninitialized = true;
        }
    }
}