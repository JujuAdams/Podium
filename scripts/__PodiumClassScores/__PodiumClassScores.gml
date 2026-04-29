/// @param scoresID
/// @param leaderboardName
/// @param formattedServiceRef
/// @param range
/// @param higherValueIsBetter
/// @param displayType
/// @param refreshPeriod

function __PodiumClassScores(_scoresID, _leaderboardName, _formattedServiceRef, _range, _higherValueIsBetter, _displayType, _refreshPeriod) constructor
{
    static _system = __PodiumSystem();
    
    __scoresID            = _scoresID;
    __formattedServiceRef = _formattedServiceRef;
    __range               = _range;
    __higherValueIsBetter = _higherValueIsBetter;
    __displayType         = _displayType;
    __refreshPeriod       = _refreshPeriod;
    
    __state            = PODIUM_STATE_NO_DATA;
    __lastReceivedTime = -infinity;
    __data             = [];
    
    if (PODIUM_USING_STEAMWORKS)
    {
        if (_displayType == PODIUM_DISPLAY_NUMERIC)
        {
            var _steamDisplayType = lb_disp_numeric;
        }
        else if (_displayType == PODIUM_DISPLAY_TIME_SEC)
        {
            var _steamDisplayType = lb_disp_time_sec;
        }
        else if (_displayType == PODIUM_DISPLAY_TIME_MS)
        {
            var _steamDisplayType = lb_disp_time_ms;
        }
        else
        {
            __PodiumError($"Leaderboard \"{_formattedServiceRef}\" has unhandled display type `{_displayType}`");
        }
        
        var _sortMethod = _higherValueIsBetter? lb_sort_descending : lb_sort_ascending;
        
        steam_create_leaderboard(__formattedServiceRef, _sortMethod, _steamDisplayType);
    }
    
    
    
    static __ClearCache = function()
    {
        __state = PODIUM_STATE_NO_DATA;
        array_resize(__data, 0);
        __lastReceivedTime = -infinity;
    }
    
    static __GetCached = function()
    {
        return (current_time - __lastReceivedTime < 5*60_000); //Every five minutes
    }
    
    static __GetData = function()
    {
        return __data;
    }
    
    static __ReceiveData = function(_data)
    {
        __data = _data;
        __lastReceivedTime = current_time;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    static __GetScoresInternal = function(_refresh)
    {
        if (__asyncID != undefined)
        {
            //Pending
            return;
        }
        
        __lastRequestTime = current_time;
        
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
            }
            else if (PODIUM_USING_GAMECENTER)
            {
                ///////
                // GameCenter
                ///////
                
                if (__refreshPeriod == PODIUM_REFRESH_NEVER)
                {
                    var _timeScope = GameCenter_Leaderboard_TimeScope_AllTime;
                }
                else if (__refreshPeriod == PODIUM_REFRESH_DAILY)
                {
                    var _timeScope = GameCenter_Leaderboard_TimeScope_Today;
                }
                else if (__refreshPeriod == PODIUM_REFRESH_WEEKLY)
                {
                    var _timeScope = GameCenter_Leaderboard_TimeScope_Week;
                }
                
                if ((__range == PODIUM_RANGE_TOP) || (__range == PODIUM_RANGE_AROUND))
                {
                    __asyncID = GameCenter_Leaderboard_LoadGlobal(__formattedServiceRef, _timeScope, 1, 10);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = GameCenter_Leaderboard_LoadFriendsOnly(__formattedServiceRef, _timeScope, 1, 10);
                }
                
                __PodiumRegisterSocialAsyncID(__asyncID, function(_aborted)
                {
                    if (PODIUM_VERBOSE)
                    {
                        __PodiumTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                    }
                    
                    __asyncID = undefined;
                    array_resize(__data, 0);
                    
                    if (not _aborted)
                    {
                        //TODO
                    }
                    
                    if (_aborted)
                    {
                        __SetErrorState();
                    }
                    else
                    {
                        __state = PODIUM_STATE_SUCCESS;
                    }
                    
                    __ExecuteCallback();
                });
            }
            else if (_system.__playServicesAvailable)
            {
                ///////
                // Google Play Services
                ///////
                
                if (__refreshPeriod == PODIUM_REFRESH_NEVER)
                {
                    var _timeScope = Leaderboard_TIME_SPAN_ALL_TIME;
                }
                else if (__refreshPeriod == PODIUM_REFRESH_DAILY)
                {
                    var _timeScope = Leaderboard_TIME_SPAN_DAILY;
                }
                else if (__refreshPeriod == PODIUM_REFRESH_WEEKLY)
                {
                    var _timeScope = Leaderboard_TIME_SPAN_WEEKLY;
                }
                
                if (__range == PODIUM_RANGE_TOP)
                {
                    __asyncID = GooglePlayServices_Leaderboard_LoadTopScores(__formattedServiceRef, _timeScope, Leaderboard_COLLECTION_PUBLIC, 10, _refresh);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = GooglePlayServices_Leaderboard_LoadTopScores(__formattedServiceRef, _timeScope, Leaderboard_COLLECTION_SOCIAL, 10, _refresh);
                }
                else if (__range == PODIUM_RANGE_AROUND)
                {
                    __asyncID = GooglePlayServices_Leaderboard_LoadPlayerCenteredScores(__formattedServiceRef, _timeScope, Leaderboard_COLLECTION_PUBLIC, 10, _refresh);
                }
                
                __PodiumRegisterSocialAsyncID(__asyncID, function(_aborted)
                {
                    if (PODIUM_VERBOSE)
                    {
                        __PodiumTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                    }
                    
                    __asyncID = undefined;
                    array_resize(__data, 0);
                    
                    if (not _aborted)
                    {
                        //TODO
                    }
                    
                    if (_aborted)
                    {
                        __SetErrorState();
                    }
                    else
                    {
                        __state = PODIUM_STATE_SUCCESS;
                    }
                    
                    __ExecuteCallback();
                });
            }
            else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
            {
                ///////
                // PlayFab
                ///////
                
                if (_system.__xboxUser < 0)
                {
                    __PodiumSoftError("Xbox user not set or invalid. Please set the Xbox user with `PodiumSetXboxUser()` before fetching leaderboard scores");
                }
                else if (not _system.__playFabLoggedIn)
                {
                    __PodiumWarning("Cannot get leaderboard, PlayFab login pending or failed");
                }
                else
                {
                    var _callbackFunction = function(_leaderboardData)
                    {
                        if (PODIUM_VERBOSE)
                        {
                            __PodiumTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                        }
                        
                        __asyncID = undefined;
                        array_resize(__data, 0);
                        
                        if (_leaderboardData == undefined)
                        {
                            __SetErrorState();
                        }
                        else
                        {
                            try
                            {
                                var _dataStatus    = _leaderboardData.status;
                                var _rankingsArray = _leaderboardData.data.Rankings;
                            }
                            catch(_error)
                            {
                                if (PODIUM_VERBOSE)
                                {
                                    show_debug_message(json_stringify(_leaderboardData, true));
                                    show_debug_message(_error);
                                }
                                
                                __PodiumWarning($"Failed to find expected data in returned leaderboard data \"{__formattedServiceRef}\"");
                                
                                __SetErrorState();
                                return;
                            }
                            
                            if (_dataStatus != "OK")
                            {
                                __PodiumWarning($"Leaderboard data \"{__formattedServiceRef}\" returned as not \"OK\"");
                                
                                __SetErrorState();
                                return;
                            }
                            
                            try
                            {
                                var _i = 0;
                                repeat(array_length(_rankingsArray))
                                {
                                    var _ranking = _rankingsArray[_i];
                                    array_push(__data, new __PodiumClassRanking(_ranking.DisplayName, _ranking.Scores[0], _ranking.Rank));
                                    ++_i;
                                }
                            }
                            catch(_error)
                            {
                                if (PODIUM_VERBOSE)
                                {
                                    show_debug_message(_error);
                                }
                                
                                __PodiumWarning($"Leaderboard data \"{__formattedServiceRef}\" failed to parse");
                                
                                __SetErrorState();
                                return;
                            }
                            
                            if (PODIUM_VERBOSE)
                            {
                                show_debug_message(json_stringify(__data, true));
                                __PodiumTrace($"Leaderboard data \"{__formattedServiceRef}\" parsed successfully");
                            }
                            
                            __state = PODIUM_STATE_SUCCESS;
                        }
                    
                        __ExecuteCallback();
                    };
                    
                    if (__range == PODIUM_RANGE_TOP)
                    {
                        __asyncID = __PodiumPlayFabGetLeaderboard(__formattedServiceRef, 1, 10, _callbackFunction);
                    }
                    else if (__range == PODIUM_RANGE_FRIENDS)
                    {
                        __asyncID = __PodiumPlayFabGetLeaderboardFriends(__formattedServiceRef, 1, 10, _callbackFunction);
                    }
                    else if (__range == PODIUM_RANGE_AROUND)
                    {
                        __asyncID = __PodiumPlayFabGetLeaderboardAround(__formattedServiceRef, 10, _callbackFunction);
                    }
                }
            }
            else if (PODIUM_USING_GDK)
            {
                ///////
                // Xbox & Windows GDK
                ///////
                
                if (_system.__xboxUser < 0)
                {
                    __PodiumSoftError("Xbox user not set or invalid. Please set the gamepad with `PodiumSetXboxUser()` before fetching leaderboard scores");
                }
                else
                {
                    if (__range == PODIUM_RANGE_TOP)
                    {
                        __asyncID = xboxone_stats_get_leaderboard(_system.__xboxUser, __formattedServiceRef, 10, 1, false, not __leaderboard.__higherValueIsBetter);
                    }
                    else if (__range == PODIUM_RANGE_FRIENDS)
                    {
                        __asyncID = xboxone_stats_get_social_leaderboard(_system.__xboxUser, __formattedServiceRef, 10, 1, false, not __leaderboard.__higherValueIsBetter, false);
                    }
                    else if (__range == PODIUM_RANGE_AROUND)
                    {
                        __asyncID = xboxone_stats_get_leaderboard(_system.__xboxUser, __formattedServiceRef, 10, 0, true, not __leaderboard.__higherValueIsBetter);
                    }
                    
                    __PodiumRegisterSocialAsyncID(__asyncID, function(_aborted)
                    {
                        if (PODIUM_VERBOSE)
                        {
                            __PodiumTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                        }
                        
                        __asyncID = undefined;
                        array_resize(__data, 0);
                        
                        if (not _aborted)
                        {
                            //TODO
                        }
                        
                        if (_aborted)
                        {
                            __SetErrorState();
                        }
                        else
                        {
                            __state = PODIUM_STATE_SUCCESS;
                        }
                        
                        __ExecuteCallback();
                    });
                }
            }
            else if (PODIUM_ON_PS5)
            {
                ///////
                // PS5
                ///////
                
                if (_system.__psGamepad < 0)
                {
                    __PodiumSoftError("PlayStation gamepad not set or invalid. Please set the gamepad with `PodiumSetPSGamepad()` before fetching leaderboard scores");
                }
                else
                {
                    var _func = function(_aborted)
                    {
                        if (PODIUM_VERBOSE)
                        {
                            __PodiumTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                        }
                        
                        __asyncID = undefined;
                        array_resize(__data, 0);
                        
                        if (not _aborted)
                        {
                            var _entryNumber = async_load[? "numentries"];
                            var _i = 1; //1-indexed
                            repeat(_entryNumber)
                            {
                                var _rank     = async_load[? $"rank{_i}"];
                                var _playerID = async_load[? $"playerid{_i}"]; //Called "player ID" but actually seems to be a name?
                                var _score    = async_load[? $"scorevalue{_i}"];
                                
                                array_push(__data, new __PodiumClassRanking(_playerID, _score, _rank));
                                ++_i;
                            }
                        }
                        
                        if (_aborted)
                        {
                            __SetErrorState();
                        }
                        else
                        {
                            __state = PODIUM_STATE_SUCCESS;
                        }
                        
                        __ExecuteCallback();
                    };
                    
                    if (__range == PODIUM_RANGE_TOP)
                    {
                        psn_get_leaderboard_score_range(_system.__psGamepad, __formattedServiceRef, 1, 10);
                        __PodiumRegisterPSLeaderboardScoreRange(__formattedServiceRef, _func);
                    }
                    else if (__range == PODIUM_RANGE_FRIENDS)
                    {
                        psn_get_friends_scores(_system.__psGamepad, __formattedServiceRef, 1, 10);
                        __PodiumRegisterPSLeaderboardFriends(__formattedServiceRef, _func);
                    }
                    else if (__range == PODIUM_RANGE_AROUND)
                    {
                        //TODO
                    }
                }
            }
            else if (PODIUM_ON_SWITCH)
            {
                ///////
                // Switch
                ///////
                
                if (_system.__switchNPLNUserHandle == undefined)
                {
                    __PodiumSoftError("Switch NPLN user handle not set or invalid. Please set the gamepad with `PodiumSetSwitchNPLNUserHandle()` before fetching leaderboard scores");
                }
                else if (_system.__switchNPLNUserHandle == 0)
                {
                    __PodiumWarning("Switch NPLN user handle is null, not getting scores");
                }
                else
                {
                    if ((__range == PODIUM_RANGE_TOP) || (__range == PODIUM_RANGE_FRIENDS))
                    {
                        __asyncID = switch_npln_leaderboard_get_scores_range(_system.__switchNPLNUserHandle,
                                                                             __formattedServiceRef.categoryTypeName, __formattedServiceRef.categoryID,
                                                                             __PODIUM_SWITCH_CURRENT_SEASON,
                                                                             0, 10);
                    }
                    else if (__range == PODIUM_RANGE_AROUND)
                    {
                        __asyncID = switch_npln_leaderboard_get_scores_near(_system.__switchNPLNUserHandle,
                                                                             __formattedServiceRef.categoryTypeName, __formattedServiceRef.categoryID,
                                                                            __PODIUM_SWITCH_CURRENT_SEASON,
                                                                            10);
                    }
                    
                    __PodiumRegisterSocialAsyncID(__asyncID, function(_aborted)
                    {
                        if (PODIUM_VERBOSE)
                        {
                            __PodiumTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                        }
                        
                        __asyncID = undefined;
                        array_resize(__data, 0);
                        
                        if (not _aborted)
                        {
                            if (not async_load[? "success"])
                            {
                                _aborted = true;
                            }
                            else
                            {
                                var _scoresArray = async_load[? "scores"];
                                var _i = 0;
                                repeat(array_length(_scoresArray))
                                {
                                    var _scoreStruct = _scoresArray[_i];
                                    array_push(__data, new __PodiumClassRanking(_scoreStruct.user_name, _scoreStruct.score, _scoreStruct.rank));
                                    ++_i;
                                }
                            }
                        }
                        
                        if (_aborted)
                        {
                            __SetErrorState();
                        }
                        else
                        {
                            __state = PODIUM_STATE_SUCCESS;
                        }
                        
                        __ExecuteCallback();
                    });
                }
                
                __SetErrorState();
            }
            else
            {
                __PodiumSoftError($"Unhandled OS {os_type}. Please report this error");
            }
            
            if (__asyncID != undefined)
            {
                if (__state != PODIUM_STATE_ERROR)
                {
                    if (PODIUM_VERBOSE)
                    {
                        __PodiumTrace($"Started leaderboard fetch for \"{__formattedServiceRef}\" using range `{__range}`");
                    }
                    
                    __state = PODIUM_STATE_PENDING;
                }
            }
        }
        
        return undefined;
    }
}