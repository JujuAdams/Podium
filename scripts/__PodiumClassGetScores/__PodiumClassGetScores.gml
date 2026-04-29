/// @param leaderboardName
/// @param range

function __PodiumClassGetScores(_leaderboardName, _range) : __PodiumClassCommonOp() constructor
{
    __opType = __PODIUM_OP_GET_SCORES;
    
    if (PODIUM_VERBOSE)
    {
        __PodiumTrace($"Created GET_SCORES operation {string(ptr(self))}: \"{_leaderboardName}\", range = {_range}");
    }
    
    __leaderboardName = _leaderboardName;
    __range           = _range;
    
    
    
    
    
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
                    __asyncID = steam_download_scores(__PodiumLeaderboardGetFormattedServiceRef(__leaderboardName), 1, 10);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = steam_download_friends_scores(__PodiumLeaderboardGetFormattedServiceRef(__leaderboardName));
                }
                else if (__range == PODIUM_RANGE_AROUND)
                {
                    __asyncID = steam_download_scores_around_user(__PodiumLeaderboardGetFormattedServiceRef(__leaderboardName), -5, 5);
                }
            }
            else if (PODIUM_ON_SWITCH)
            {
                ///////
                // Switch
                ///////
                
                var _serviceRef = __PodiumLeaderboardFind(__leaderboardName).__serviceRef;
                
                if (__range == PODIUM_RANGE_TOP)
                {
                    __asyncID = switch_npln_leaderboard_get_scores_range(_system.__switchNPLNUserHandle,
                                                                         _serviceRef.categoryTypeName, _serviceRef.categoryID,
                                                                         __PODIUM_SWITCH_CURRENT_SEASON,
                                                                         0, 10);
                }
                else if (__range == PODIUM_RANGE_FRIENDS)
                {
                    __asyncID = switch_npln_leaderboard_get_scores_of_friends(_system.__switchNPLNUserHandle, true,
                                                                              _serviceRef.categoryTypeName, _serviceRef.categoryID,
                                                                              __PODIUM_SWITCH_CURRENT_SEASON);
                }
                else if (__range == PODIUM_RANGE_AROUND)
                {
                    __asyncID = switch_npln_leaderboard_get_scores_near(_system.__switchNPLNUserHandle,
                                                                        _serviceRef.categoryTypeName, _serviceRef.categoryID,
                                                                        __PODIUM_SWITCH_CURRENT_SEASON,
                                                                        10);
                }
            }
        }
        
        if ((__asyncID != undefined) && (__asyncID >= 0))
        {
            array_push(_pendingArray, self);
        }
        else
        {
            __Complete(PODIUM_STATE_ERROR);
        }
    }
    
    
    
    
    
    static __Complete = function(_status)
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
        
        var _scoresStruct = __PodiumScoresFind(__leaderboardName, __range);
        if (_scoresStruct == undefined)
        {
            __PodiumSoftError($"Scores struct not found for leaderboard \"{__PodiumLeaderboardGetFormattedServiceRef(__leaderboardName)}\"");
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
                    __PodiumWarning($"Failed to parse returned leaderboard data for \"{__PodiumLeaderboardGetFormattedServiceRef(__leaderboardName)}\"");
                    
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