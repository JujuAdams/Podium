#macro __PODIUM_SWITCH_CURRENT_SEASON  (-2147483648)

#macro PODIUM_MIN_SUBMIT_DELAY  100 //ms between requests
#macro PODIUM_MIN_FETCH_DELAY   500 //ms between requests
#macro PODIUM_MAX_FREQUENCY      25 //per minute

#macro __PODIUM_MAX_SIMULTANEOUS_OPERATIONS  1

#macro __PODIUM_OP_SUBMIT      0
#macro __PODIUM_OP_GET_SCORES  1

#macro __PODIUM_OFFLINE_DATA_VERSION  3

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
        __signedInWhilstUninitialized = false;
        __runningDefinitions = false;
        
        __signInState = PODIUM_USER_SIGNED_OUT;
        __usernameHint = "";
        __username = undefined;
        
        __offlineOnly       = false;
        __localChanged      = false;
        __offlineRecordDict = {};
        
        __lastActivityTime  = -infinity;
        __queuedSubmitArray = [];
        __queuedFetchArray  = [];
        __pendingArray      = [];
        __activityArray     = [];
        
        __psGamepad               = -1;
        __psNPAvailabilityAsyncID = undefined;
        
        __xboxUser = int64(0);
        
        __switchAccountIndex   = undefined;
        __switchNPLNUserHandle = undefined;
        __switchUserID         = undefined;
        
        __steamAvailable = false;
        
        __gameCenterPlayerID = undefined;
        
        __playServicesAvailable = false;
        __playServicesID        = undefined;
        
        __playFabLoggedIn              = false;
        __playFabXboxTokenAndSignature = undefined;
        __playFabSessionTicket         = undefined;
        __playFabEntityToken           = undefined;
        __playFabEntityID              = undefined;
        
        __leaderboardDict            = {};
        __httpAsyncIDMap             = ds_map_create();
        __psLeaderboardSubmitMap     = ds_map_create();
        __psLeaderboardScoreRangeMap = ds_map_create();
        __psLeaderboardFriendsMap    = ds_map_create();
        __psLeaderboardUserMap       = ds_map_create();
        
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
            
            if (PODIUM_ON_XBOX_SERIES)
            {
                if ((__xboxUser > 0) && (__signInState == PODIUM_USER_SIGNED_IN))
                {
                    if (not xboxone_user_is_signed_in(__xboxUser))
                    {
                        __PodiumWarning($"User {__xboxUser} signed out");
                        __signInState = PODIUM_USER_SIGNED_OUT;
                        __PodiumGlobalClearRemoteCaches();
                    }
                    else if (not os_is_network_connected(false))
                    {
                        __PodiumWarning($"Device lost network connection");
                        __signInState = PODIUM_USER_SIGNED_OUT;
                        __PodiumGlobalClearRemoteCaches();
                    }
                }
            }
            
            var _i = array_length(__pendingArray)-1;
            repeat(array_length(__pendingArray))
            {
                with(__pendingArray[_i])
                {
                    if (current_time - __activityTime > 30_000)
                    {
                        __Complete(PODIUM_LEADERBOARD_ERROR, undefined);
                    }
                }
                
                --_i;
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
            if (array_length(__queuedSubmitArray) > 0)
            {
                while(array_length(__queuedSubmitArray) > 0)
                {
                    if (current_time - __lastActivityTime < PODIUM_MIN_SUBMIT_DELAY)
                    {
                        break;
                    }
                    else
                    {
                        __lastActivityTime = current_time;
                        
                        if ((array_length(__activityArray) < PODIUM_MAX_FREQUENCY)
                        &&  (array_length(__pendingArray) < max(1, __PODIUM_MAX_SIMULTANEOUS_OPERATIONS)))
                        {
                            __queuedSubmitArray[0].__Dispatch();
                        }
                        else
                        {
                            break;
                        }
                    }
                }
            }
            
            while(array_length(__queuedFetchArray) > 0)
            {
                if (current_time - __lastActivityTime < PODIUM_MIN_FETCH_DELAY)
                {
                    break;
                }
                else
                {
                    __lastActivityTime = current_time;
                    
                    if ((array_length(__activityArray) < PODIUM_MAX_FREQUENCY)
                    &&  (array_length(__pendingArray) < max(1, __PODIUM_MAX_SIMULTANEOUS_OPERATIONS)))
                    {
                        __queuedFetchArray[0].__Dispatch();
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