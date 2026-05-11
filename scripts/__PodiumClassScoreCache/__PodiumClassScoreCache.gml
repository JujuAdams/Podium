function __PodiumClassScoreCache() constructor
{
    __state = PODIUM_LEADERBOARD_NOT_FETCHED;
    __data  = [];
    __lastReceivedTime = -infinity;
    
    
    
    static __ClearCache = function()
    {
        __SetState(PODIUM_LEADERBOARD_NOT_FETCHED);
        
        __data = [];
        __lastReceivedTime = -infinity;
    }
    
    static __GetUsingCache = function()
    {
        if (PODIUM_ON_DESKTOP || PODIUM_ON_MOBILE)
        {
            return (current_time - __lastReceivedTime < 1_000*PODIUM_GREEDY_CACHE_TIMEOUT);
        }
        else
        {
            return (not is_infinity(__lastReceivedTime));
        }
    }
    
    static __GetReceivedTime = function()
    {
        return __lastReceivedTime;
    }
    
    static __GetScoresData = function()
    {
        return __data;
    }
    
    static __ReceiveData = function(_data, _state)
    {
        __data = _data;
        __lastReceivedTime = current_time;
        
        __SetState(_state);
    }
    
    static __SetState = function(_state)
    {
        __state = _state;
    }
    
    static __GetState = function()
    {
        return __state;
    }
    
    
    
    //static __GetScoresInternal = function(_refresh)
    //{
    //    if (__asyncID != undefined)
    //    {
    //        //Pending
    //        return;
    //    }
    //    
    //    __lastRequestTime = current_time;
    //    
    //    if (PodiumGetOfflineOnly())
    //    {
    //        //TODO
    //    }
    //    else
    //    {
    //        if (PODIUM_USING_GAMECENTER)
    //        {
    //            ///////
    //            // GameCenter
    //            ///////
    //            
    //            if (__refreshPeriod == PODIUM_REFRESH_NEVER)
    //            {
    //                var _timeScope = GameCenter_Leaderboard_TimeScope_AllTime;
    //            }
    //            else if (__refreshPeriod == PODIUM_REFRESH_DAILY)
    //            {
    //                var _timeScope = GameCenter_Leaderboard_TimeScope_Today;
    //            }
    //            else if (__refreshPeriod == PODIUM_REFRESH_WEEKLY)
    //            {
    //                var _timeScope = GameCenter_Leaderboard_TimeScope_Week;
    //            }
    //            
    //            if ((__range == PODIUM_RANGE_TOP) || (__range == PODIUM_RANGE_AROUND))
    //            {
    //                __asyncID = GameCenter_Leaderboard_LoadGlobal(__formattedServiceData, _timeScope, 1, 10);
    //            }
    //            else if (__range == PODIUM_RANGE_FRIENDS)
    //            {
    //                __asyncID = GameCenter_Leaderboard_LoadFriendsOnly(__formattedServiceData, _timeScope, 1, 10);
    //            }
    //            
    //            __PodiumRegisterSocialAsyncID(__asyncID, function(_aborted)
    //            {
    //                if (PODIUM_VERBOSE)
    //                {
    //                    __PodiumTrace($"Received leaderboard data for \"{__formattedServiceData}\" using range `{__range}`");
    //                }
    //                
    //                __asyncID = undefined;
    //                array_resize(__data, 0);
    //                
    //                if (not _aborted)
    //                {
    //                    //TODO
    //                }
    //                
    //                if (_aborted)
    //                {
    //                    __SetErrorState();
    //                }
    //                else
    //                {
    //                    __state = PODIUM_LEADERBOARD_SUCCESS;
    //                }
    //                
    //                __ExecuteCallback();
    //            });
    //        }
    //        else if (_system.__playServicesAvailable)
    //        {
    //            ///////
    //            // Google Play Services
    //            ///////
    //            
    //            if (__refreshPeriod == PODIUM_REFRESH_NEVER)
    //            {
    //                var _timeScope = Leaderboard_TIME_SPAN_ALL_TIME;
    //            }
    //            else if (__refreshPeriod == PODIUM_REFRESH_DAILY)
    //            {
    //                var _timeScope = Leaderboard_TIME_SPAN_DAILY;
    //            }
    //            else if (__refreshPeriod == PODIUM_REFRESH_WEEKLY)
    //            {
    //                var _timeScope = Leaderboard_TIME_SPAN_WEEKLY;
    //            }
    //            
    //            if (__range == PODIUM_RANGE_TOP)
    //            {
    //                __asyncID = GooglePlayServices_Leaderboard_LoadTopScores(__formattedServiceData, _timeScope, Leaderboard_COLLECTION_PUBLIC, 10, _refresh);
    //            }
    //            else if (__range == PODIUM_RANGE_FRIENDS)
    //            {
    //                __asyncID = GooglePlayServices_Leaderboard_LoadTopScores(__formattedServiceData, _timeScope, Leaderboard_COLLECTION_SOCIAL, 10, _refresh);
    //            }
    //            else if (__range == PODIUM_RANGE_AROUND)
    //            {
    //                __asyncID = GooglePlayServices_Leaderboard_LoadPlayerCenteredScores(__formattedServiceData, _timeScope, Leaderboard_COLLECTION_PUBLIC, 10, _refresh);
    //            }
    //            
    //            __PodiumRegisterSocialAsyncID(__asyncID, function(_aborted)
    //            {
    //                if (PODIUM_VERBOSE)
    //                {
    //                    __PodiumTrace($"Received leaderboard data for \"{__formattedServiceData}\" using range `{__range}`");
    //                }
    //                
    //                __asyncID = undefined;
    //                array_resize(__data, 0);
    //                
    //                if (not _aborted)
    //                {
    //                    //TODO
    //                }
    //                
    //                if (_aborted)
    //                {
    //                    __SetErrorState();
    //                }
    //                else
    //                {
    //                    __state = PODIUM_LEADERBOARD_SUCCESS;
    //                }
    //                
    //                __ExecuteCallback();
    //            });
    //        }
    //        else if (PODIUM_USING_GDK)
    //        {
    //            ///////
    //            // Xbox & Windows GDK
    //            ///////
    //            
    //            if (_system.__xboxUser < 0)
    //            {
    //                __PodiumSoftError("Xbox user not set or invalid. Please set the gamepad with `PodiumSetXboxUser()` before fetching leaderboard scores");
    //            }
    //            else
    //            {
    //                if (__range == PODIUM_RANGE_TOP)
    //                {
    //                    __asyncID = xboxone_stats_get_leaderboard(_system.__xboxUser, __formattedServiceData, 10, 1, false, not __leaderboard.__higherValueIsBetter);
    //                }
    //                else if (__range == PODIUM_RANGE_FRIENDS)
    //                {
    //                    __asyncID = xboxone_stats_get_social_leaderboard(_system.__xboxUser, __formattedServiceData, 10, 1, false, not __leaderboard.__higherValueIsBetter, false);
    //                }
    //                else if (__range == PODIUM_RANGE_AROUND)
    //                {
    //                    __asyncID = xboxone_stats_get_leaderboard(_system.__xboxUser, __formattedServiceData, 10, 0, true, not __leaderboard.__higherValueIsBetter);
    //                }
    //                
    //                __PodiumRegisterSocialAsyncID(__asyncID, function(_aborted)
    //                {
    //                    if (PODIUM_VERBOSE)
    //                    {
    //                        __PodiumTrace($"Received leaderboard data for \"{__formattedServiceData}\" using range `{__range}`");
    //                    }
    //                    
    //                    __asyncID = undefined;
    //                    array_resize(__data, 0);
    //                    
    //                    if (not _aborted)
    //                    {
    //                        //TODO
    //                    }
    //                    
    //                    if (_aborted)
    //                    {
    //                        __SetErrorState();
    //                    }
    //                    else
    //                    {
    //                        __state = PODIUM_LEADERBOARD_SUCCESS;
    //                    }
    //                    
    //                    __ExecuteCallback();
    //                });
    //            }
    //        }
    //        else if (PODIUM_ON_PS5)
    //        {
    //            ///////
    //            // PS5
    //            ///////
    //            
    //            if (_system.__psGamepad < 0)
    //            {
    //                __PodiumSoftError("PlayStation gamepad not set or invalid. Please set the gamepad with `PodiumSetPSGamepad()` before fetching leaderboard scores");
    //            }
    //            else
    //            {
    //                var _func = function(_aborted)
    //                {
    //                    if (PODIUM_VERBOSE)
    //                    {
    //                        __PodiumTrace($"Received leaderboard data for \"{__formattedServiceData}\" using range `{__range}`");
    //                    }
    //                    
    //                    __asyncID = undefined;
    //                    array_resize(__data, 0);
    //                    
    //                    if (not _aborted)
    //                    {
    //                        var _entryNumber = async_load[? "numentries"];
    //                        var _i = 1; //1-indexed
    //                        repeat(_entryNumber)
    //                        {
    //                            var _rank     = async_load[? $"rank{_i}"];
    //                            var _playerID = async_load[? $"playerid{_i}"]; //Called "player ID" but actually seems to be a name?
    //                            var _score    = async_load[? $"scorevalue{_i}"];
    //                            
    //                            array_push(__data, new __PodiumClassRecord(_playerID, _score, _rank, false));
    //                            ++_i;
    //                        }
    //                    }
    //                    
    //                    if (_aborted)
    //                    {
    //                        __SetErrorState();
    //                    }
    //                    else
    //                    {
    //                        __state = PODIUM_LEADERBOARD_SUCCESS;
    //                    }
    //                    
    //                    __ExecuteCallback();
    //                };
    //                
    //                if (__range == PODIUM_RANGE_TOP)
    //                {
    //                    psn_get_leaderboard_score_range(_system.__psGamepad, __formattedServiceData, 1, 10);
    //                    __PodiumRegisterPSLeaderboardScoreRange(__formattedServiceData, _func);
    //                }
    //                else if (__range == PODIUM_RANGE_FRIENDS)
    //                {
    //                    psn_get_friends_scores(_system.__psGamepad, __formattedServiceData, 1, 10);
    //                    __PodiumRegisterPSLeaderboardFriends(__formattedServiceData, _func);
    //                }
    //                else if (__range == PODIUM_RANGE_AROUND)
    //                {
    //                    //TODO
    //                }
    //            }
    //        }
    //        else
    //        {
    //            __PodiumSoftError($"Unhandled OS {os_type}. Please report this error");
    //        }
    //        
    //        if (__asyncID != undefined)
    //        {
    //            if (__state != PODIUM_LEADERBOARD_ERROR)
    //            {
    //                if (PODIUM_VERBOSE)
    //                {
    //                    __PodiumTrace($"Started leaderboard fetch for \"{__formattedServiceData}\" using range `{__range}`");
    //                }
    //                
    //                __state = PODIUM_LEADERBOARD_WAITING;
    //            }
    //        }
    //    }
    //    
    //    return undefined;
    //}
}