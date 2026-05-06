function __PodiumUserSignedIn()
{
    static _system = __PodiumSystem();
    
    __PodiumTrace("User signed in");
    
    _system.__signInState = PODIUM_USER_SIGNED_IN;
    
    __PodiumClearAllCaches();
    __PodiumSubmitAllPendingOfflineRecords();
}