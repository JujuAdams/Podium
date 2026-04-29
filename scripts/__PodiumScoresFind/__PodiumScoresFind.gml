/// @param leaderboardName
/// @param range

function __PodiumScoresFind(_leaderboardName, _range)
{
    if ((_range != PODIUM_RANGE_TOP) && (_range != PODIUM_RANGE_FRIENDS) && (_range != PODIUM_RANGE_AROUND))
    {
        __PodiumSoftError($"Unhandled range `{_range}`");
        return false;
    }
    
    var _struct = __PodiumLeaderboardFind(_leaderboardName);
    if (not is_struct(_struct)) return undefined;
    
    return _struct.__EnsureScoresStruct(_range);
}