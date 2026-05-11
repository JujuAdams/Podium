/// @param leaderboardName
/// @param value
/// @param [metadataString=""]
/// @param [priority=high]
/// @param [clearCache=true]

function PodiumSubmit(_leaderboardName, _value, _metadataString = "", _priority = PODIUM_PRIORITY_HIGH, _clearCache = true)
{
    static _system = __PodiumSystem();
    static _queuedSubmitArray = _system.__queuedSubmitArray;
    
    var _leaderboardStruct = __PodiumLeaderboardFind(_leaderboardName);
    if (is_struct(_leaderboardStruct))
    {
        if ((not PodiumGetSignedIn()) || PodiumGetOfflineOnly())
        {
            //If we're running offline-only leaderboards or we're not signed in, only store a local value
            __PodiumStoreOfflineRecord(_leaderboardName, _value, _metadataString, not PodiumGetOfflineOnly());
        }
        else if (PodiumGetLeaderboardDisabled(_leaderboardName))
        {
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Cannot submit score, \"{_leaderboardName}\" is disabled");
            }
        }
        else
        {
            var _struct = new __PodiumClassOpSubmit(variable_clone(_leaderboardStruct.__GetFormattedServiceData(0)), _value, _metadataString, _clearCache);
            if (__PodiumGetUniqueOperation(_struct))
            {
                if (PODIUM_VERBOSE)
                {
                    __PodiumTrace($"Created SUBMIT operation {string(ptr(_struct))}: ({_value} -> \"{_struct.__formattedServiceData}\")");
                }
                
                if (_clearCache)
                {
                    //Clear the cache for this leaderboard because it may be invalidated by the user's score
                    PodiumClearRemoteCache(_leaderboardName, PODIUM_RANGE_TOP,     0);
                    PodiumClearRemoteCache(_leaderboardName, PODIUM_RANGE_AROUND,  0);
                    PodiumClearRemoteCache(_leaderboardName, PODIUM_RANGE_FRIENDS, 0);
                    PodiumClearRemoteCache(_leaderboardName, PODIUM_RANGE_USER,    0);
                }
                
                __PodiumStoreOfflineRecord(_leaderboardName, _value, _metadataString, not PodiumGetOfflineOnly());
                
                if (_priority == PODIUM_PRIORITY_HIGH)
                {
                    array_insert(_queuedSubmitArray, 0, _struct);
                }
                else if (_priority == PODIUM_PRIORITY_IMMEDIATE)
                {
                    _struct.__Dispatch();
                }
                else
                {
                    if (PODIUM_RUNNING_FROM_IDE && (_priority == PODIUM_PRIORITY_NO_REQUEST))
                    {
                        __PodiumWarning($"Cannot use `PODIUM_PRIORITY_NO_REQUEST` with `PodiumSubmit()`; reinterpreting as `PODIUM_PRIORITY_NORMAL`");
                    }
                    
                    array_push(_queuedSubmitArray, _struct);
                }
            }
        }
    }
}