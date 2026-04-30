/// @param leaderboardName
/// @param value
/// @param [priority=normal]
/// @param [clearCache=true]

function PodiumSubmit(_leaderboardName, _value, _priority = PODIUM_PRIORITY_NORMAL, _clearCache = true)
{
    static _system = __PodiumSystem();
    static _queuedArray = _system.__queuedArray;
    
    if (not PodiumGetUserSignedIn())
    {
        __PodiumSoftError($"User not signed in:\n- On Switch, call `PodiumSetSwitchNPLNUserHandle()`\n- On PlayStation 5, call `PodiumSetPSGamepad()`\n- On Xbox & Windows GDK, call `PodiumSetXboxUser()`");
        return undefined;
    }
    
    var _leaderboardStruct = __PodiumLeaderboardFind(_leaderboardName);
    if (is_struct(_leaderboardStruct))
    {
        var _struct = new __PodiumClassSubmit(variable_clone(_leaderboardStruct.__GetFormattedServiceData()), _value);
        
        if (not __PodiumGetUniqueOperation(_struct))
        {
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Discarding SUBMIT operation {string(ptr(self))} as an identical operation is queued or pending");
            }
        }
        else
        {
            if (_clearCache)
            {
                //Clear the cache for this leaderboard because it may be invalidated by the user's score
                PodiumClearCache(_leaderboardName, -1);
            }
            
            if (_priority == PODIUM_PRIORITY_HIGH)
            {
                array_insert(_queuedArray, _struct, 0);
            }
            else if (_priority == PODIUM_PRIORITY_IMMEDIATE)
            {
                _struct.__Dispatch();
            }
            else
            {
                array_push(_queuedArray, _struct);
            }
        }
    }
}