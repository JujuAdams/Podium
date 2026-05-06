/// @param leaderboardName
/// @param value
/// @param [metadataString=""]
/// @param [priority=high]
/// @param [clearCache=true]

function PodiumSubmit(_leaderboardName, _value, _metadataString = "", _priority = PODIUM_PRIORITY_HIGH, _clearCache = true)
{
    static _system = __PodiumSystem();
    static _queuedArray = _system.__queuedArray;
    
    var _leaderboardStruct = __PodiumLeaderboardFind(_leaderboardName);
    if (is_struct(_leaderboardStruct))
    {
        if ((not PodiumGetUserSignedIn()) || _system.__local)
        {
            //If we're running local-only leaderboards or we're not signed in, only store a local value
            __PodiumLocalScoreStore(_leaderboardName, _value, _metadataString);
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
                    PodiumClearRemoteCache(_leaderboardName, undefined, 0);
                }
                
                __PodiumLocalScoreStore(_leaderboardName, _value, _metadataString);
                
                if (_priority == PODIUM_PRIORITY_HIGH)
                {
                    array_insert(_queuedArray, 0, _struct);
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
                    
                    array_push(_queuedArray, _struct);
                }
            }
        }
    }
}