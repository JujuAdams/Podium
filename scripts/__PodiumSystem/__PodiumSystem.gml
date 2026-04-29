#macro __PODIUM_SWITCH_CURRENT_SEASON  (-2147483648)

#macro PODIUM_MIN_DELAY  0 //ms between requests
#macro PODIUM_MAX_FREQUENCY  25  //per minute
#macro __PODIUM_MAX_SIMULTANEOUS_OPERATIONS  1

#macro __PODIUM_OP_SUBMIT      0
#macro __PODIUM_OP_GET_SCORES  1

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
        
        __local        = false;
        __localChanged = false;
        __localData    = {};
        
        __lastActivityTime = -infinity;
        __pendingArray  = [];
        __queuedArray   = [];
        __activityArray = [];
        
        __psGamepad            = -1;
        __xboxUser             = int64(0);
        __switchNPLNUserHandle = 0;
        
        __steamAvailable        = false;
        __playServicesAvailable = false;
        
        __playFabLoggedIn              = false;
        __playFabXboxTokenAndSignature = undefined;
        __playFabSessionTicket         = undefined;
        __playFabEntityToken           = undefined;
        
        __leaderboardDict            = {};
        __httpAsyncIDMap             = ds_map_create();
        __socialAsyncIDMap           = ds_map_create();
        __psLeaderboardScoreRangeMap = ds_map_create();
        __psLeaderboardFriendsMap    = ds_map_create();
        
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            static _createdInstance = false;
            if (not _createdInstance)
            {
                _createdInstance = true;
                instance_create_depth(0, 0, 0, __PodiumController);
            }
            else
            {
                if (not instance_exists(__PodiumController))
                {
                    __PodiumError("`__PodiumController` has been destroyed or deactivated");
                }
                else if (not __PodiumController.persistent)
                {
                    __PodiumError("`__PodiumController` has been set to not persistent");
                }
            }
            
            //Clean up recent activity arrays
            while(array_length(__activityArray) > 0)
            {
                if (current_time - __activityArray[0].__activityTime > 60_000)
                {
                    array_shift(__activityArray);
                }
                else
                {
                    break;
                }
            }
            
            //Dispatch queued operations
            while(array_length(__queuedArray) > 0)
            {
                if (current_time - __lastActivityTime < PODIUM_MIN_DELAY)
                {
                    break;
                }
                else
                {
                    __lastActivityTime = current_time;
                    
                    if ((array_length(__activityArray) < PODIUM_MAX_FREQUENCY)
                    &&  (array_length(__pendingArray) < max(1, __PODIUM_MAX_SIMULTANEOUS_OPERATIONS)))
                    {
                        __queuedArray[0].__Dispatch();
                    }
                    else
                    {
                        break;
                    }
                }
            }
        },
        [], -1));
    }
    
    return _system;
}