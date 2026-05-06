/// @param leaderboard
/// @param range
/// @param seasonOffset

function __PodiumClassOpGetScores(_leaderboard, _range, _seasonOffset) : __PodiumClassOpCommon() constructor
{
    __opType = __PODIUM_OP_GET_SCORES;
    
    __leaderboard  = _leaderboard;
    __range        = _range;
    __seasonOffset = _seasonOffset;
    
    __formattedServiceData = variable_clone(_leaderboard.__GetFormattedServiceData(__seasonOffset));
    
    
    
    static __OperationEqual = function(_other)
    {
        return (is_instanceof(_other, __PodiumClassOpGetScores)
             && (__leaderboard  == _other.__leaderboard) //Don't need to check this as its covered by the service data but it's a convenient early-out
             && (__range        == _other.__range)
             && (__seasonOffset == _other.__seasonOffset)
             && (__formattedServiceData.__formattedRef == _other.__formattedServiceData.__formattedRef));
    }
    
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
        
        //Catch edge case where the clock ticks over!
        __formattedServiceData = variable_clone(__leaderboard.__GetFormattedServiceData(__seasonOffset));
        
        if (PodiumGetOfflineOnly())
        {
            __PodiumSoftError("OfflineOnly defensive branch reached. Please report this error");
        }
        else
        {
            if (PODIUM_STEAM_AVAILABLE)
            {
                ///////
                // Steam
                ///////
                
                if (__range == PODIUM_RANGE_TOP)
                {
                    __asyncID = steam_download_scores(__formattedServiceData.__formattedRef, 1, 10);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = steam_download_friends_scores(__formattedServiceData.__formattedRef);
                }
                else if (__range == PODIUM_RANGE_AROUND)
                {
                    __asyncID = steam_download_scores_around_user(__formattedServiceData.__formattedRef, -5, 5);
                }
                else if (__range == PODIUM_RANGE_USER)
                {
                    __asyncID = steam_download_scores_around_user(__formattedServiceData.__formattedRef, 0, 0);
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
                                                                         __formattedServiceData.switch.__formattedCategoryTypeName, __formattedServiceData.switch.categoryID,
                                                                         __PODIUM_SWITCH_CURRENT_SEASON,
                                                                         0, 10);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = switch_npln_leaderboard_get_scores_of_friends(_system.__switchNPLNUserHandle, true,
                                                                              __formattedServiceData.switch.__formattedCategoryTypeName, __formattedServiceData.switch.categoryID,
                                                                              __PODIUM_SWITCH_CURRENT_SEASON);
                }
                else if (__range == PODIUM_RANGE_AROUND)
                {
                    __asyncID = switch_npln_leaderboard_get_scores_near(_system.__switchNPLNUserHandle,
                                                                        __formattedServiceData.switch.__formattedCategoryTypeName, __formattedServiceData.switch.categoryID,
                                                                        __PODIUM_SWITCH_CURRENT_SEASON,
                                                                        10);
                }
                else if (__range == PODIUM_RANGE_USER)
                {
                    __asyncID = switch_npln_leaderboard_get_scores_near(_system.__switchNPLNUserHandle,
                                                                        __formattedServiceData.switch.__formattedCategoryTypeName, __formattedServiceData.switch.categoryID,
                                                                        __PODIUM_SWITCH_CURRENT_SEASON,
                                                                        0);
                }
            }
            else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
            {
                var _callbackFunction = function(_resultJSON)
                {
                    if (_resultJSON == undefined)
                    {
                        __Complete(PODIUM_LEADERBOARD_ERROR, undefined);
                    }
                    else if (_resultJSON[$ "status"] != "OK")
                    {
                        __PodiumWarning($"Leaderboard data \"{__formattedServiceData.playFab}\" returned as not \"OK\"");
                        __Complete(PODIUM_LEADERBOARD_ERROR, undefined);
                    }
                    else
                    {
                        __Complete(PODIUM_LEADERBOARD_SUCCESS, _resultJSON);
                    }
                };
                
                if (__range == PODIUM_RANGE_TOP)
                {
                    __asyncID = __PodiumPlayFabGetLeaderboardTop(__formattedServiceData.playFab, 1, 10, _callbackFunction);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = __PodiumPlayFabGetLeaderboardFriends(__formattedServiceData.playFab, 1, 10, _callbackFunction);
                }
                else if (__range == PODIUM_RANGE_AROUND)
                {
                    __asyncID = __PodiumPlayFabGetLeaderboardAround(__formattedServiceData.playFab, 10, _callbackFunction);
                }
                else if (__range == PODIUM_RANGE_USER)
                {
                    __asyncID = __PodiumPlayFabGetLeaderboardUser(__formattedServiceData.playFab, _callbackFunction);
                }
            }
            else
            {
                //TODO
            }
        }
        
        if ((__asyncID != undefined) && (__asyncID >= 0))
        {
            __leaderboard.__EnsureScoresStruct(__range, __seasonOffset).__SetState(PODIUM_LEADERBOARD_WAITING);
            array_push(_pendingArray, self);
        }
        else
        {
            __Complete(PODIUM_LEADERBOARD_ERROR, undefined);
        }
    }
    
    
    
    static __Complete = function(_status, _playFabData)
    {
        if (__completed) return;
        
        var _leaderboardName = __formattedServiceData.leaderboardName;
        
        __completed = true;
        __activityTime = PodiumGetOfflineOnly()? -infinity : current_time;
        
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
        
        var _scoresStruct = __leaderboard.__EnsureScoresStruct(__range, __seasonOffset);
        if (_scoresStruct == undefined)
        {
            __PodiumSoftError($"Scores struct not found for leaderboard \"{_leaderboardName}\"");
        }
        else
        {
            var _data = [];
            
            if (PODIUM_STEAM_AVAILABLE)
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
                    
                    var _scoresArray = _json.entries;
                    var _i = 0;
                    repeat(array_length(_scoresArray))
                    {
                        var _scoreStruct = _scoresArray[_i];
                        
                        var _metadataString = "";
                        var _dataBase64 = _scoreStruct[$ "data"];
                        if (_dataBase64 != undefined)
                        {
                            try
                            {
                                var _buffer = buffer_base64_decode(_dataBase64);
                                var _string = buffer_read(_buffer, buffer_text);
                                buffer_delete(_buffer);
                                _metadataString = _string;
                            }
                            catch(_error)
                            {
                                show_debug_message(_error);
                                __PodiumWarning("Failed to decode metadata string");
                            }
                        }
                        
                        array_push(_data, new __PodiumClassRecord(_scoreStruct.name, _scoreStruct.score, _scoreStruct.rank, _scoreStruct.userID, _metadataString, false));
                        ++_i;
                    }
                }
                catch(_error)
                {
                    __PodiumWarning($"Failed to parse returned leaderboard data for \"{__formattedServiceData}\"");
                    
                    _json = undefined;
                    __status = PODIUM_LEADERBOARD_ERROR;
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
                
                try
                {
                    var _i = 0;
                    repeat(array_length(_scoresArray))
                    {
                        var _scoreStruct = _scoresArray[_i];
                        var _metadataString = _scoreStruct.data[$ "_"] ?? "";
                        array_push(_data, new __PodiumClassRecord(_scoreStruct.user_name, _scoreStruct.score, _scoreStruct.rank, _scoreStruct.user_id, _metadataString, false));
                        ++_i;
                    }
                }
                catch(_error)
                {
                    __PodiumWarning($"Failed to parse returned leaderboard data for \"{__formattedServiceData}\"");
                    
                    _json = undefined;
                    __status = PODIUM_LEADERBOARD_ERROR;
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
                    
                    __PodiumWarning($"Failed to find expected data in returned leaderboard data \"{_leaderboardName}\"");
                    __status = PODIUM_LEADERBOARD_ERROR;
                }
                
                if (__status == PODIUM_LEADERBOARD_SUCCESS)
                {
                    try
                    {
                        var _i = 0;
                        repeat(array_length(_rankingsArray))
                        {
                            var _ranking = _rankingsArray[_i];
                            array_push(_data, new __PodiumClassRecord(_ranking.DisplayName, _ranking.Scores[0], _ranking.Rank, _ranking.Entity.Id, _ranking[$ "Metadata"] ?? "", false));
                            ++_i;
                        }
                    }
                    catch(_error)
                    {
                        if (PODIUM_VERBOSE)
                        {
                            show_debug_message(_error);
                        }
                        
                        __PodiumWarning($"Leaderboard data \"{_leaderboardName}\" failed to parse");
                        __status = PODIUM_LEADERBOARD_ERROR;
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
            
            _scoresStruct.__ReceiveData(_data, __status);
            
            //Find player scores and update our local cache provided that this is not a historic score
            if ((__status == PODIUM_LEADERBOARD_SUCCESS) && (__seasonOffset == 0))
            {
                var _playerIndex = PodiumGetUserScoreIndex(_leaderboardName, __range, __seasonOffset);
                if (_playerIndex >= 0)
                {
                    var _playerRecord = _data[_playerIndex];
                    __PodiumStoreOfflineRecord(_leaderboardName, _playerRecord.value, _playerRecord.metadataString, false);
                }
            }
        }
        
        if (is_callable(__callback))
        {
            __callback(_status, __callbackMetadata);
        }
    }
}