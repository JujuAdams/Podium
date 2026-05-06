/// @param leaderboardName
/// @param range
/// @param _seasonOffset

function __PodiumScoreCacheFind(_leaderboardName, _range, _seasonOffset)
{
    if ((_range != PODIUM_RANGE_TOP)
     && (_range != PODIUM_RANGE_FRIENDS)
     && (_range != PODIUM_RANGE_AROUND)
     && (_range != PODIUM_RANGE_USER))
    {
        __PodiumSoftError($"Unhandled range `{_range}`");
        return false;
    }
    
    _seasonOffset = floor(_seasonOffset);
    if (_seasonOffset > 0)
    {
        __PodiumSoftError($"Season offset must be a negative number or zero");
        return undefined;
    }
    
    var _struct = __PodiumLeaderboardFind(_leaderboardName);
    if (not is_struct(_struct)) return undefined;
    
    return _struct.__EnsureScoresStruct(_range, _seasonOffset);
}