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
        
        var _index = array_get_index(_queuedFetchArray, self);
        if (_index >= 0) array_delete(_queuedFetchArray, _index, 1);
        
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
                    __asyncID = steam_download_scores(__formattedServiceData.__formattedRef, 1, 100);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = steam_download_friends_scores(__formattedServiceData.__formattedRef);
                }
                else if (__range == PODIUM_RANGE_AROUND)
                {
                    __asyncID = steam_download_scores_around_user(__formattedServiceData.__formattedRef, -50, 50);
                }
                else if (__range == PODIUM_RANGE_USER)
                {
                    __asyncID = steam_download_scores_around_user(__formattedServiceData.__formattedRef, 0, 0);
                }
            }
            else if (PODIUM_ON_SWITCH_X)
            {
                ///////
                // Switch
                ///////
                
                if (__range == PODIUM_RANGE_TOP)
                {
                    __asyncID = switch_npln_leaderboard_get_scores_range(_system.__switchNPLNUserHandle,
                                                                         __formattedServiceData.switch.__formattedCategoryTypeName, __formattedServiceData.switch.categoryID,
                                                                         __PODIUM_SWITCH_CURRENT_SEASON,
                                                                         0, 100);
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
                                                                        100);
                }
                else if (__range == PODIUM_RANGE_USER)
                {
                    __asyncID = switch_npln_leaderboard_get_scores_near(_system.__switchNPLNUserHandle,
                                                                        __formattedServiceData.switch.__formattedCategoryTypeName, __formattedServiceData.switch.categoryID,
                                                                        __PODIUM_SWITCH_CURRENT_SEASON,
                                                                        0);
                }
            }
            else if (PODIUM_ON_PS5)
            {
                ///////
                // PlayStation 5
                ///////
                
                var _func = function(_cancelled)
                {
                    __Complete(((not _cancelled) && async_load[? "succeeded"])? PODIUM_LEADERBOARD_SUCCESS : PODIUM_LEADERBOARD_ERROR, undefined);
                }
                
                if (__range == PODIUM_RANGE_TOP)
                {
                    __asyncID = 999_999;
                    psn_get_leaderboard_score_range(_system.__psGamepad, __formattedServiceData.__formattedRef, 0, 99); //zero-indexed
                    __PodiumRegisterPSLeaderboardScoreRange(__formattedServiceData.__formattedRef, _func);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = 999_999;
                    psn_get_friends_scores(_system.__psGamepad, __formattedServiceData.__formattedRef, 0, 99); //zero-indexed
                    __PodiumRegisterPSLeaderboardFriends(__formattedServiceData.__formattedRef, _func);
                }
                else if (__range == PODIUM_RANGE_AROUND)
                {
                    //FIXME - This doesn't seem to be supported. Can maybe make a request against the user's leaderboard ranking and then request a range around it?
                    __PodiumWarning("`PODIUM_RANGE_AROUND` not supported on PS5 (yet)");
                }
                else if (__range == PODIUM_RANGE_USER)
                {
                    __asyncID = 999_999;
                    psn_get_leaderboard_score(_system.__psGamepad, __formattedServiceData.__formattedRef);
                    __PodiumRegisterPSLeaderboardUser(__formattedServiceData.__formattedRef, _func);
                }
            }
            else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
            {
                ///////
                // PlayFab
                ///////
                
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
                    __asyncID = __PodiumPlayFabGetLeaderboardTop(__formattedServiceData.playFab, 1, 100, __seasonOffset, _callbackFunction);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = __PodiumPlayFabGetLeaderboardFriends(__formattedServiceData.playFab, 1, 100, __seasonOffset, _callbackFunction);
                }
                else if (__range == PODIUM_RANGE_AROUND)
                {
                    __asyncID = __PodiumPlayFabGetLeaderboardAround(__formattedServiceData.playFab, 50, __seasonOffset, _callbackFunction);
                }
                else if (__range == PODIUM_RANGE_USER)
                {
                    __asyncID = __PodiumPlayFabGetLeaderboardUser(__formattedServiceData.playFab, __seasonOffset, _callbackFunction);
                }
            }
            else if (PODIUM_USING_XBOX_LEADERBOARDS)
            {
                ///////
                // Xbox native
                ///////
                
                var _func = function(_cancelled)
                {
                    __Complete(((not _cancelled) && (async_load[? "error"] == 0))? PODIUM_LEADERBOARD_SUCCESS : PODIUM_LEADERBOARD_ERROR, undefined);
                }
                
                if (__range == PODIUM_RANGE_TOP)
                {
                    __asyncID = 999_999;
                    xboxone_stats_get_leaderboard(_system.__xboxUser, __formattedServiceData.xbox, 100, 0, false, __formattedServiceData.descending);
                    __PodiumRegisterXboxLeaderboard(_func);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = 999_999;
                    xboxone_stats_get_social_leaderboard(_system.__xboxUser, __formattedServiceData.xbox, 100, 0, false, __formattedServiceData.descending, false);
                    __PodiumRegisterXboxLeaderboard(_func);
                }
                else if (__range == PODIUM_RANGE_AROUND)
                {
                    __asyncID = 999_999;
                    xboxone_stats_get_leaderboard(_system.__xboxUser, __formattedServiceData.xbox, 100, 0, true, __formattedServiceData.descending);
                    __PodiumRegisterXboxLeaderboard(_func);
                }
                else if (__range == PODIUM_RANGE_USER)
                {
                    __asyncID = 999_999;
                    xboxone_stats_get_leaderboard(_system.__xboxUser, __formattedServiceData.xbox, 1, 0, true, __formattedServiceData.descending);
                    __PodiumRegisterXboxLeaderboard(_func);
                }
            }
            else if (PODIUM_PLAY_SERVICES_AVAILABLE)
            {
                ///////
                // Google Play Services
                ///////
                
                var _span = __formattedServiceData.daily? Leaderboard_TIME_SPAN_DAILY : Leaderboard_TIME_SPAN_ALL_TIME;
                
                if (__range == PODIUM_RANGE_TOP)
                {
                    __asyncID = GooglePlayServices_Leaderboard_LoadTopScores(__formattedServiceData.playServices, _span, Leaderboard_COLLECTION_PUBLIC, 10, false);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = GooglePlayServices_Leaderboard_LoadTopScores(__formattedServiceData.playServices, _span, Leaderboard_COLLECTION_SOCIAL, 10, false);
                }
                else if (__range == PODIUM_RANGE_AROUND)
                {
                    __asyncID = GooglePlayServices_Leaderboard_LoadPlayerCenteredScores(__formattedServiceData.playServices, _span, Leaderboard_COLLECTION_PUBLIC, 10, false);
                }
                else if (__range == PODIUM_RANGE_USER)
                {
                    __asyncID = GooglePlayServices_Leaderboard_LoadPlayerCenteredScores(__formattedServiceData.playServices, _span, Leaderboard_COLLECTION_SOCIAL, 1, false);
                }
            }
            else if (PODIUM_USING_GAMECENTER)
            {
                ///////
                // GameCenter
                ///////
                
                if (__range == PODIUM_RANGE_TOP)
                {
                    __asyncID = GameCenter_Leaderboard_LoadGlobal(__formattedServiceData.gameCenter, GameCenter_Leaderboard_TimeScope_AllTime, 1, 10);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = GameCenter_Leaderboard_LoadFriendsOnly(__formattedServiceData.gameCenter, GameCenter_Leaderboard_TimeScope_AllTime, 1, 10);
                }
                else if (__range == PODIUM_RANGE_AROUND)
                {
                    //TODO - Is this supported?
                }
                else if (__range == PODIUM_RANGE_USER)
                {
                    //TODO - Is this supported?
                }
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
        
        var _index = array_get_index(_queuedFetchArray, self);
        if (_index >= 0) array_delete(_queuedFetchArray, _index, 1);
        
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
                        
                        array_push(_data, new __PodiumClassRecord(_scoreStruct.name,
                                                                  __PodiumConvertFromSubmitScore(_scoreStruct.score, __formattedServiceData),
                                                                  _scoreStruct.rank,
                                                                  _scoreStruct.userID,
                                                                  _metadataString, false));
                        ++_i;
                    }
                }
                catch(_error)
                {
                    __PodiumWarning($"Failed to parse returned leaderboard data for \"{__formattedServiceData}\"");
                    __status = PODIUM_LEADERBOARD_ERROR;
                }
            }
            else if (PODIUM_ON_SWITCH_X)
            {
                ///////
                // Switch
                ///////
                
                if (PODIUM_VERBOSE)
                {
                    __PodiumTrace($"Using Switch parser");
                }
                
                try
                {
                    var _scoresArray = async_load[? "scores"];
                    var _i = 0;
                    repeat(array_length(_scoresArray))
                    {
                        var _scoreStruct = _scoresArray[_i];
                        var _metadataString = _scoreStruct.data[$ "_"] ?? "";
                        array_push(_data, new __PodiumClassRecord(_scoreStruct.user_name,
                                                                  __PodiumConvertFromSubmitScore(_scoreStruct.score, __formattedServiceData),
                                                                  _scoreStruct.rank,
                                                                  _scoreStruct.user_id,
                                                                  _metadataString, false));
                        ++_i;
                    }
                }
                catch(_error)
                {
                    __PodiumWarning($"Failed to parse returned leaderboard data for \"{__formattedServiceData}\"");
                    __status = PODIUM_LEADERBOARD_ERROR;
                }
            }
            else if (PODIUM_ON_PS5)
            {
                ///////
                // PlayStation 5
                ///////
                
                if (async_load < 0)
                {
                    __status = PODIUM_LEADERBOARD_ERROR;
                }
                else
                {
                    try
                    {
                        if (__range == PODIUM_RANGE_USER)
                        {
                            if (PODIUM_VERBOSE)
                            {
                                __PodiumTrace($"Using PlayStation 5 user parser");
                            }
                            
                            var _map = async_load;
                            var _entryCount = async_load[? $"numentries"];
                            if (_entryCount == undefined)
                            {
                                throw "Incomplete user record";
                            }
                            else if (_entryCount == 0)
                            {
                                if (PODIUM_VERBOSE)
                                {
                                    __PodiumTrace($"Player has no score");
                                }
                            }
                            else
                            {
                                var _rank     = async_load[? $"rank"    ];
                                var _playerID = async_load[? $"playerid"]; //Called "player ID" but actually seems to be a name?
                                var _score    = async_load[? $"score"   ];
                                var _comment  = async_load[? $"comment" ] ?? "";
                                
                                if ((_rank != undefined) && (_playerID != undefined) && (_score != undefined))
                                {
                                    array_push(_data, new __PodiumClassRecord(_playerID, __PodiumConvertFromSubmitScore(_score, __formattedServiceData), _rank, _playerID, _comment, false));
                                }
                                else
                                {
                                    throw "Incomplete user record";
                                }
                            }
                        }
                        else
                        {
                            if (PODIUM_VERBOSE)
                            {
                                __PodiumTrace($"Using PlayStation 5 general parser");
                            }
                            
                            var _entryNumber = async_load[? "numentries"];
                            var _i = 0;
                            repeat(_entryNumber)
                            {
                                var _rank     = async_load[? $"rank{_i}"      ];
                                var _playerID = async_load[? $"playerid{_i}"  ]; //Called "player ID" but actually seems to be a name?
                                var _score    = async_load[? $"scorevalue{_i}"];
                                var _comment  = async_load[? $"comment{_i}"   ] ?? "";
                                
                                if ((_rank != undefined) && (_playerID != undefined) && (_score != undefined))
                                {
                                    array_push(_data, new __PodiumClassRecord(_playerID, __PodiumConvertFromSubmitScore(_score, __formattedServiceData), _rank, _playerID, _comment, false));
                                }
                                
                                ++_i;
                            }
                        }
                    }
                    catch(_error)
                    {
                        show_debug_message(_error);
                        __PodiumWarning($"Failed to parse returned leaderboard data for \"{__formattedServiceData}\"");
                        __status = PODIUM_LEADERBOARD_ERROR;
                    }
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
                
                if (_playFabData == undefined)
                {
                    __PodiumWarning("Returned PlayFab data is invalid");
                    __status = PODIUM_LEADERBOARD_ERROR;
                }
                else
                {
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
                }
                
                if (__status == PODIUM_LEADERBOARD_SUCCESS)
                {
                    try
                    {
                        var _i = 0;
                        repeat(array_length(_rankingsArray))
                        {
                            var _ranking = _rankingsArray[_i];
                            
                            var _score = undefined;
                            try
                            {
                                _score = real(_ranking.Scores[0]);
                            }
                            catch(_error)
                            {
                                if (PODIUM_VERBOSE)
                                {
                                    __PodiumTrace("Failed to convert score to number");
                                }
                            }
                            
                            if (_score != undefined)
                            {
                                var _unpackedData = __PodiumPlayFabMetadataUnpack(_ranking[$ "Metadata"] ?? "");
                                array_push(_data, new __PodiumClassRecord(_ranking.DisplayName,
                                                                          __PodiumConvertFromSubmitScore(_score, __formattedServiceData),
                                                                          _ranking.Rank,
                                                                          _unpackedData.__xboxUser,
                                                                          _unpackedData.__metadataString, false));
                            }
                            
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
            else if (PODIUM_USING_XBOX_LEADERBOARDS)
            {
                ///////
                // Xbox native
                ///////
                
                try
                {
                    if (PODIUM_VERBOSE)
                    {
                        __PodiumTrace($"Using Xbox native parser");
                    }
                    
                    var _entryNumber = async_load[? "numentries"];
                    var _i = 0;
                    repeat(_entryNumber)
                    {
                        var _rank     = async_load[? $"Rank{_i}"    ];
                        var _name     = async_load[? $"Player{_i}"  ];
                        var _playerID = async_load[? $"Playerid{_i}"];
                        var _score    = async_load[? $"Score{_i}"   ];
                        
                        try
                        {
                            _score = real(_score);
                        }
                        catch(_error)
                        {
                            _score = undefined;
                        }
                        
                        if ((_name != undefined) && (_rank != undefined) && (_playerID != undefined) && (_score != undefined))
                        {
                            array_push(_data, new __PodiumClassRecord(_name, __PodiumConvertFromSubmitScore(_score, __formattedServiceData), _rank, _playerID, "", false));
                        }
                        
                        ++_i;
                    }
                }
                catch(_error)
                {
                    show_debug_message(_error);
                    __PodiumWarning($"Failed to parse returned leaderboard data for \"{__formattedServiceData}\"");
                    __status = PODIUM_LEADERBOARD_ERROR;
                }
            }
            else if (PODIUM_PLAY_SERVICES_AVAILABLE)
            {
                ///////
                // Google Play Services
                ///////
                
                if (PODIUM_VERBOSE)
                {
                    __PodiumTrace($"Using Google Play Services parser");
                }
                
                var _scoresArray = undefined;
                try
                {
                    var _scoresArray = json_parse(async_load[? "data"]);
                    var _i = 0;
                    repeat(array_length(_scoresArray))
                    {
                        var _scoreStruct = _scoresArray[_i];
                        
                        var _metadataString = __PodiumPlayServicesDecode(_scoreStruct[$ "scoreTag"] ?? "");
                        array_push(_data, new __PodiumClassRecord(_scoreStruct.scoreHolderDisplayName,
                                                                  __PodiumConvertFromSubmitScore(_scoreStruct.rawScore, __formattedServiceData),
                                                                  _scoreStruct.rank,
                                                                  _scoreStruct.scoreHolder.playerId,
                                                                  _metadataString,
                                                                  false));
                        
                        ++_i;
                    }
                }
                catch(_error)
                {
                    __PodiumWarning($"Failed to parse returned leaderboard data for \"{__formattedServiceData}\"");
                    __status = PODIUM_LEADERBOARD_ERROR;
                }
            }
            else if (PODIUM_USING_GAMECENTER)
            {
                ///////
                // GameCenter
                ///////
                
                if (PODIUM_VERBOSE)
                {
                    __PodiumTrace($"Using GameCenter parser");
                }
                
                try
                {
                    var _scoreCount = async_load[? "entries"];
                    var _i = 0;
                    repeat(_scoreCount)
                    {
                        var _infoJSON = async_load[? $"entry_info_{_i}"   ];
                        var _score    = async_load[? $"entry_score_{_i}"  ];
                        var _rank     = async_load[? $"entry_rank_{_i}"   ];
                        var _metadata = async_load[? $"entry_context_{_i}"];
                        
                        var _info        = undefined;
                        var _displayName = undefined;
                        var _playerID    = undefined;
                        try
                        {
                            _info        = json_parse(_infoJSON);
                            _displayName = _info.displayName;
                            _playerID    = _info.playerID;
                        }
                        catch(_error)
                        {
                            show_debug_message(_error);
                        }
                        
                        if ((_displayName != undefined) && (_score != undefined) && (_rank != undefined) && (_playerID != undefined) && (_metadata != undefined))
                        {
                            array_push(_data, new __PodiumClassRecord(_displayName, __PodiumConvertFromSubmitScore(_score, __formattedServiceData), _rank, _playerID, _metadata, false));
                        }
                        else
                        {
                            __PodiumWarning($"Could not parse entry {_i}");
                        }
                        
                        ++_i;
                    }
                }
                catch(_error)
                {
                    __PodiumWarning($"Failed to parse returned leaderboard data for \"{__formattedServiceData}\"");
                    __status = PODIUM_LEADERBOARD_ERROR;
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
                    
                    //Try to store the new incoming score. This will return `true` if the incoming remote score is better than what we have locally
                    var _remoteIsBetter = __PodiumStoreOfflineRecord(_leaderboardName, _playerRecord.value, _playerRecord.metadataString, false);
                    
                    //Figure out if the Xbox leaderboards are out of sync with our offline scores
                    if (PODIUM_USING_XBOX_LEADERBOARDS && (not _remoteIsBetter))
                    {
                        var _offlineRecord = _system.__offlineRecordDict[$ _leaderboardName];
                        if (is_struct(_offlineRecord) && (_playerRecord.value != _offlineRecord.__value)) //Verify the offline score is actually different to the remote score
                        {
                            var _leaderboardStruct = __PodiumLeaderboardFind(_leaderboardName);
                            if (is_struct(_leaderboardStruct) && _leaderboardStruct.__GetOfflineRecordValid(_offlineRecord)) //Verify the offline score is valid (important for dailies)
                            {
                                //Mark the record as pending
                                _offlineRecord.__pending = true;
                                _system.__localChanged = true;
                                
                                //Resubmit our local score
                                _system.__skipXboxBetterCheck = true;
                                PodiumSubmit(_name, _offlineRecord.__value, _offlineRecord.__metadata);
                                _system.__skipXboxBetterCheck = false;
                            }
                        }
                    }
                }
            }
        }
        
        if (is_callable(__callback))
        {
            __callback(_status, __callbackMetadata);
        }
    }
}