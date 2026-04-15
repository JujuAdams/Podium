function __PodiumPlayFabXboxRequestToken()
{
    static _system = __PodiumSystem();
    
    __PodiumEnsureControllerInstance();
    
    with(_system)
    {
        if (PODIUM_USING_WINDOWS_GDK)
        {
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Requesting token and signature from PlayFab for user `{__xboxUser}` (Windows)");
            }
            
            var _return = xboxone_get_token_and_signature(__xboxUser, "https://playfabapi.com/", "POST", "{}", "", false);
        }
        else
        {
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Requesting token and signature from PlayFab for user `{__xboxUser}` (Xbox)");
            }
            
            //Function isn't in fnames ( ͡° ͜ʖ ͡°)
            var _return = xboxlive_get_token_and_signature(__xboxUser, "https://playfabapi.com/", "POST", "{}", "", false);
        }
        
        if (_return < 0)
        {
            __PodiumSoftError($"Failed to get Xbox token and signature for user `{__xboxUser}`"); 
        }
    }
}