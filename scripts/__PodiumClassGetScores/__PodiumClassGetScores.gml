/// @param leaderboard
/// @param range

function __PodiumClassGetScores(_leaderboard, _range) : __PodiumClassCommonOp() constructor
{
    __opType = __PODIUM_OP_GET_SCORES;
    
    if (PODIUM_VERBOSE)
    {
        __PodiumTrace($"Created GET_SCORES operation {string(ptr(self))}: \"{_leaderboard.__serviceData.__ref}\", range = {_range}");
    }
    
    __leaderboard = _leaderboard;
    __range       = _range;
    
    __formattedServiceData = _leaderboard.__GetFormattedServiceData();
    
    
    
    static __Dispatch = function()
    {
        if (__dispatched) return;
        
        __dispatched = true;
        __activityTime = current_time;
        
        if (PODIUM_VERBOSE)
        {
            __PodiumTrace($"Dispatching GET_SCORES operation {string(ptr(self))}");
        }
        
        var _index = array_get_index(_queuedArray, self);
        if (_index >= 0) array_delete(_queuedArray, _index, 1);
        
        array_push(_activityArray, self);
        
        __formattedServiceData = __leaderboard.__GetFormattedServiceData();
        
        if (_system.__local)
        {
            //TODO
        }
        else
        {
            if (_system.__steamAvailable)
            {
                ///////
                // Steam
                ///////
                
                if (__range == PODIUM_RANGE_TOP)
                {
                    __asyncID = steam_download_scores(__formattedServiceData, 1, 10);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = steam_download_friends_scores(__formattedServiceData);
                }
                else if (__range == PODIUM_RANGE_AROUND)
                {
                    __asyncID = steam_download_scores_around_user(__formattedServiceData, -5, 5);
                }
            }
            else if (PODIUM_ON_SWITCH)
            {
                ///////
                // Switch
                ///////
                
                if (__range == PODIUM_RANGE_TOP)
                {
                    __asyncID = switch_npln_leaderboard_get_scores_range(_system.__switchNPLNUserHandle,
                                                                         __formattedServiceData.__categoryTypeName, __formattedServiceData.__categoryID,
                                                                         __PODIUM_SWITCH_CURRENT_SEASON,
                                                                         0, 10);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = switch_npln_leaderboard_get_scores_of_friends(_system.__switchNPLNUserHandle, true,
                                                                              __formattedServiceData.__categoryTypeName, __formattedServiceData.__categoryID,
                                                                              __PODIUM_SWITCH_CURRENT_SEASON);
                }
                else if (__range == PODIUM_RANGE_AROUND)
                {
                    __asyncID = switch_npln_leaderboard_get_scores_near(_system.__switchNPLNUserHandle,
                                                                        __formattedServiceData.__categoryTypeName, __formattedServiceData.__categoryID,
                                                                        __PODIUM_SWITCH_CURRENT_SEASON,
                                                                        10);
                }
            }
            else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
            {
                var _callbackFunction = function(_resultJSON)
                {
                    if (_resultJSON == undefined)
                    {
                        __Complete(PODIUM_STATE_ERROR, undefined);
                    }
                    else if (_resultJSON[$ "status"] != "OK")
                    {
                        __PodiumWarning($"Leaderboard data \"{__formattedServiceData.__leaderboardName}\" returned as not \"OK\"");
                        __Complete(PODIUM_STATE_ERROR, undefined);
                    }
                    else
                    {
                        __Complete(PODIUM_STATE_SUCCESS, _resultJSON);
                    }
                };
                
                if (__range == PODIUM_RANGE_TOP)
                {
                    __asyncID = __PodiumPlayFabGetLeaderboard(__formattedServiceData.__leaderboardName, 1, 10, _callbackFunction);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = __PodiumPlayFabGetLeaderboardFriends(__formattedServiceData.__leaderboardName, 1, 10, _callbackFunction);
                }
                else if (__range == PODIUM_RANGE_AROUND)
                {
                    __asyncID = __PodiumPlayFabGetLeaderboardAround(__formattedServiceData.__leaderboardName, 10, _callbackFunction);
                }
            }
        }
        
        if ((__asyncID != undefined) && (__asyncID >= 0))
        {
            array_push(_pendingArray, self);
        }
        else
        {
            __Complete(PODIUM_STATE_ERROR, undefined);
        }
    }
    
    
    
    static __Complete = function(_status, _playFabData)
    {
        if (__completed) return;
        
        __completed = true;
        __activityTime = current_time;
        
        if (PODIUM_VERBOSE)
        {
            __PodiumTrace($"Completing GET_SCORES operation {string(ptr(self))}: provisional status = {_status}");
        }
        
        __status = _status;
        __asyncID = undefined;
        
        var _index = array_get_index(_queuedArray, self);
        if (_index >= 0) array_delete(_queuedArray, _index, 1);
        
        var _index = array_get_index(_pendingArray, self);
        if (_index >= 0) array_delete(_pendingArray, _index, 1);
        
        var _scoresStruct = __leaderboard.__EnsureScoresStruct(__range);
        if (_scoresStruct == undefined)
        {
            __PodiumSoftError($"Scores struct not found for leaderboard \"{__formattedServiceData}\"");
        }
        else
        {
            var _data = [];
            
            if (_system.__steamAvailable)
            {
                ///////
                // Steam
                ///////
                
                if (PODIUM_VERBOSE)
                {
                    __PodiumTrace($"Using Steamworks parser");
                }
                
                var _json = undefined;
                try
                {
                    _json = json_parse(async_load[? "entries"]);
                    if (not is_array(_json.entries)) throw 666;
                    
                    _data = _json.entries;
                }
                catch(_error)
                {
                    __PodiumWarning($"Failed to parse returned leaderboard data for \"{__formattedServiceData}\"");
                    
                    _json = undefined;
                    __status = PODIUM_STATE_ERROR;
                }
            }
            else if (PODIUM_ON_SWITCH)
            {
                ///////
                // Switch
                ///////
                
                if (PODIUM_VERBOSE)
                {
                    __PodiumTrace($"Using Switch parser");
                }
                
                var _scoresArray = async_load[? "scores"];
                var _i = 0;
                repeat(array_length(_scoresArray))
                {
                    var _scoreStruct = _scoresArray[_i];
                    array_push(_data, new __PodiumClassRanking(_scoreStruct.user_name, _scoreStruct.score, _scoreStruct.rank));
                    ++_i;
                }
            }
            else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
            {
                ///////
                // PlayFab
                ///////
                
                if (PODIUM_VERBOSE)
                {
                    __PodiumTrace($"Using PlayFab parser");
                }
                
                try
                {
                    var _rankingsArray = _playFabData.data.Rankings;
                }
                catch(_error)
                {
                    if (PODIUM_VERBOSE)
                    {
                        show_debug_message(json_stringify(_playFabData, true));
                        show_debug_message(_error);
                    }
                    
                    __PodiumWarning($"Failed to find expected data in returned leaderboard data \"{__formattedServiceData.__leaderboardName}\"");
                    __status = PODIUM_STATE_ERROR;
                }
                
                if (__status == PODIUM_STATE_SUCCESS)
                {
                    try
                    {
                        var _i = 0;
                        repeat(array_length(_rankingsArray))
                        {
                            var _ranking = _rankingsArray[_i];
                            array_push(_data, new __PodiumClassRanking(_ranking.DisplayName, _ranking.Scores[0], _ranking.Rank));
                            ++_i;
                        }
                    }
                    catch(_error)
                    {
                        if (PODIUM_VERBOSE)
                        {
                            show_debug_message(_error);
                        }
                        
                        __PodiumWarning($"Leaderboard data \"{__formattedServiceData.__leaderboardName}\" failed to parse");
                        __status = PODIUM_STATE_ERROR;
                    }
                    
                    if (PODIUM_VERBOSE)
                    {
                        show_debug_message(json_stringify(_data, true));
                    }
                }
            }
            
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Completing GET_SCORES operation {string(ptr(self))}: final status = {__status}, found {array_length(_data)} entries");
            }
            
            _scoresStruct.__ReceiveData(_data);
        }
        
        if (is_callable(__callback))
        {
            __callback(_status, __callbackMetadata);
        }
    }
}