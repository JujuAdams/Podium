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
        
        __initialized = false;
        __runningDefinitions = false;
        
        __localChanged = false;
        __localData = {};
        
        __psGamepad = -1;
        __xboxUser = int64(0);
        
        __switchAccountIndex   = undefined;
        __switchNPLNUserHandle = undefined;
        
        __leaderboardDict            = {};
        __steamAsyncIDMap            = ds_map_create();
        __systemAsyncIDMap           = ds_map_create();
        __httpAsyncIDMap             = ds_map_create();
        __socialAsyncIDMap           = ds_map_create();
        __psLeaderboardScoreRangeMap = ds_map_create();
        __psLeaderboardFriendsMap    = ds_map_create();
        
        __steamAvailable        = false;
        __playServicesAvailable = false;
        
        __playFabLoggedIn              = false;
        __playFabXboxTokenAndSignature = undefined;
        __playFabSessionTicket         = undefined;
        __playFabEntityToken           = undefined;
    }
    
    return _system;
}