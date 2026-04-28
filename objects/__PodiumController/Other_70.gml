var _id = async_load[? "id"];
if (_id == PSN_LEADERBOARD_SCORE_RANGE_MSG)
{
    var _leaderboardID = async_load[? "leaderboardid"]; //The actual ID we want to check against
    var _asyncIDMap = __PodiumSystem().__psLeaderboardScoreRangeMap;
    if (ds_map_exists(_asyncIDMap, _leaderboardID))
    {
        var _callback = _asyncIDMap[? _leaderboardID];
        ds_map_delete(_asyncIDMap, _leaderboardID);
        
        _callback(false);
    }
}
else if (_id == PSN_LEADERBOARD_FRIENDS_SCORES_MSG)
{
    var _leaderboardID = async_load[? "leaderboardid"]; //The actual ID we want to check against
    var _asyncIDMap = __PodiumSystem().__psLeaderboardFriendsMap;
    if (ds_map_exists(_asyncIDMap, _leaderboardID))
    {
        var _callback = _asyncIDMap[? _leaderboardID];
        ds_map_delete(_asyncIDMap, _leaderboardID);
        
        _callback(false);
    }
}
else
{
    var _asyncIDMap = __PodiumSystem().__socialAsyncIDMap;
    if (ds_map_exists(_asyncIDMap, _id))
    {
        var _callback = _asyncIDMap[? _id];
        ds_map_delete(_asyncIDMap, _id);
        
        _callback(false);
    }
}