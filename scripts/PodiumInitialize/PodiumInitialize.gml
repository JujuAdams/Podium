/// Initializes leaderboard services and calls `__PodiumConfigLeaderboards` afterwards.

function PodiumInitialize()
{
    with(__PodiumSystem())
    {
        if (__initialized)
        {
            __PodiumSoftError("Podium has already been initialized. Please only call `PodiumInitialize()` once");
            return;
        }
        
        var _fallback = true;
        
        if (PODIUM_FORCE_LOCAL_DATA)
        {
            __PodiumTrace($"Forcing local data use via `PODIUM_FORCE_LOCAL_DATA`");
            
            _fallback = false;
            __local = true;
        }
        else if (PODIUM_ON_DESKTOP)
        {
            ///////
            // Desktop
            ///////
            
            __PodiumTrace(PODIUM_USING_STEAMWORKS? "Steam extension is present" : "Steam extension is not present");
            __PodiumTrace(PODIUM_USING_WINDOWS_GDK? "Windows GDK extension is present" : "Windows GDK extension is not present");
            
            if (PODIUM_USING_WINDOWS_GDK)
            {
                if (PODIUM_USING_STEAMWORKS)
                {
                    __PodiumError("Cannot use Steam extension and Windows GDK extension together");
                }
                
                if (PODIUM_VERBOSE)
                {
                    __PodiumTrace("Using GDK extension");
                }
                
                if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
                {
                    __PodiumTrace("Using PlayFab leaderboards on desktop");
                }
                else if (PODIUM_USING_XBOX_LEADERBOARDS)
                {
                    __PodiumTrace("Using Xbox native leaderboards on Windows");
                }
                
                _fallback = false;
                __local = false;
            }
            else if (PODIUM_USING_STEAMWORKS)
            {
                try
                {
                    __steamAvailable = steam_initialised();
                }
                catch(_error)
                {
                    __steamAvailable = false;
                }
                
                if (__steamAvailable)
                {
                    __PodiumTrace("Steam extension is initialized and available");
                    
                    if (PODIUM_VERBOSE)
                    {
                        __PodiumTrace("Using Steam remote service");
                    }
                }
                else
                {
                    __PodiumSoftError("Steam extension present in game but failed to initialize\nPlease check your Steam extension settings and that Steam is running");
                }
                
                _fallback = false;
                __local = false;
            }
        }
        else if (PODIUM_ON_IOS)
        {
            ///////
            // GameCenter
            ///////
            
            if (not PODIUM_USING_GAMECENTER)
            {
                __PodiumTrace("GameCenter extension is not present");
            }
            else
            {
                __PodiumTrace("GameCenter extension is present");
                
                if (PODIUM_VERBOSE)
                {
                    __PodiumTrace("Using GameCenter remote service");
                }
                
                _fallback = false;
                __local = false;
            }
        }
        else if (PODIUM_ON_ANDROID)
        {
            ///////
            // Google Play Services
            ///////
            
            if (not PODIUM_USING_PLAY_SERVICES)
            {
                __PodiumTrace("Googe Play Services extension is not present");
            }
            else
            {
                __PodiumTrace("Googe Play Services extension is present");
                
                try
                {
                    __playServicesAvailable = GooglePlayServices_IsAvailable();
                }
                catch(_error)
                {
                    __playServicesAvailable = false;
                }
                
                if (__playServicesAvailable)
                {
                    __PodiumTrace("Googe Play Services extension initialized and available");
                    
                    if (PODIUM_VERBOSE)
                    {
                        __PodiumTrace("Using Googe Play Services");
                    }
                    
                    _fallback = false;
                    __local = false;
                }
                else
                {
                    __PodiumWarning("Googe Play Services extension failed to initialize. Player may not have Google Play installed");
                }
            }
        }
        else if (PODIUM_ON_PS5)
        {
            ///////
            // PlayStation 5
            ///////
            
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace("Using PlayStation remote service");
            }
            
            if (PODIUM_PSN_LEADERBOARD_SERVICE_LABEL == undefined)
            {
                __PodiumError("Please set `PODIUM_PSN_LEADERBOARD_SERVICE_LABEL`");
            }
            
            psn_init_leaderboard(PODIUM_PSN_LEADERBOARD_SERVICE_LABEL);
            
            _fallback = false;
            __local = false;
        }
        else if (PODIUM_ON_XBOX_SERIES)
        {
            ///////
            // Xbox Series X/S
            ///////
            
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace("Using Xbox remote service");
            }
            
            _fallback = false;
            __local = false;
        }
        else if (PODIUM_ON_SWITCH)
        {
            ///////
            // Switch
            ///////
            
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace("Using Switch remote service");
            }
            
            _fallback = false;
            __local = false;
        }
        else
        {          
            __PodiumTrace($"Platform ({os_type}) has no explicit support, falling back on locally stored data");
            
            _fallback = false;
            __local = true;
        }
        
        if (_fallback)
        {
            __PodiumTrace($"Remote service not available, falling back on locally stored data");
            __local = true;
        }
        
        __runningDefinitions = true;
        __PodiumConfigLeaderboards();
        __runningDefinitions = false;
        
        __initialized = true;
    }
}