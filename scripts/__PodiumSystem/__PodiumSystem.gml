__PodiumSystem();

function __PodiumSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    
    if (PODIUM_RUNNING_FROM_IDE)
    {
        global.__podiumSystem = _system;
    }
    
    with(_system)
    {
        __PodiumTrace($"Welcome to Podium by Juju Adams! This is version {PODIUM_VERSION}, {PODIUM_DATE}");
        
        __runningDefinitions = true;
        
        __localChanged = false;
        __localData = {};
        
        __psGamepad = -1;
        __xboxUser = int64(0);
        __switchNPLNUserHandle = undefined;
        
        __leaderboardDict = {};
        __steamAsyncIDMap = ds_map_create();
        __httpAsyncIDMap  = ds_map_create();
        
        __steamAvailable        = false;
        __playServicesAvailable = false;
        
        __playFabLoggedIn              = false;
        __playFabXboxTokenAndSignature = undefined;
        __playFabSessionTicket         = undefined;
        __playFabEntityToken           = undefined;
        
        
        var _fallback = true;
        
        if (PODIUM_FORCE_LOCAL_DATA)
        {
            __PodiumTrace($"Forcing local data use via `PODIUM_FORCE_LOCAL_DATA` (__PodiumDefinitionsLocal)");
            
            _fallback = false;
            
            __local = true;
            __PodiumDefinitionsLocal();
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
                
                _fallback = false;
                
                __local = false;
                
                if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
                {
                    __PodiumTrace("Using PlayFab leaderboards (__PodiumDefinitionsPlayFab)");
                    __PodiumDefinitionsPlayFab();
                }
                else if (PODIUM_USING_XBOX_LEADERBOARDS)
                {
                    __PodiumTrace("Using Xbox native leaderboards (__PodiumDefinitionsXbox)");
                    __PodiumDefinitionsXbox();
                }
            }
            else if (PODIUM_USING_STEAMWORKS)
            { 
                _fallback = false;
                
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
                        __PodiumTrace("Using Steam remote service with `__PodiumDefinitionsSteam`");
                    }
                }
                else
                {
                    __PodiumSoftError("Steam extension present in game but failed to initialize\nPlease check your Steam extension settings and that Steam is running");
                }
                
                __local = false;
                __PodiumDefinitionsSteam();
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
                
                _fallback = false;
                
                if (PODIUM_VERBOSE)
                {
                    __PodiumTrace("Using GameCenter remote service with `__PodiumDefinitionsGameCenter`");
                }
                
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
                
                _fallback = false;
                
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
                        __PodiumTrace("Using Googe Play Services with `__PodiumDefinitionsPlayServices`");
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
                __PodiumTrace("Using PlayStation remote service with `__PodiumDefinitionsPlayStation`");
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
                __PodiumTrace("Using Xbox remote service with `__PodiumDefinitionsXbox`");
            }
            
            _fallback = false;
            
            __local = false;
            
            if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
            {
                __PodiumDefinitionsXbox();
            }
            else if (PODIUM_USING_XBOX_LEADERBOARDS)
            {
                __PodiumDefinitionsPlayFab();
            }
        }
        else if (PODIUM_ON_SWITCH)
        {
            ///////
            // Switch
            ///////
            
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace("Using Switch remote service with `__PodiumDefinitionsSwitch`");
            }
            
            _fallback = false;
            
            __local = false;
            __PodiumDefinitionsSwitch();
        }
        else
        {          
            __PodiumTrace($"Platform ({os_type}) has no explicit support, falling back on locally stored data with `__PodiumDefinitionsLocal`");
            
            _fallback = false;
            
            __local = true;
            __PodiumDefinitionsLocal();
        }
        
        if (_fallback)
        {
            __PodiumTrace($"Remote service not available, falling back on locally stored data with `__PodiumDefinitionsLocal`");
            
            __local = true;
            __PodiumDefinitionsLocal();
        }
        
        __runningDefinitions = false;
    }
    
    return _system;
}