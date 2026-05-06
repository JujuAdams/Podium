/// @param index
/// @param leaderboardName
/// @param range
/// @param [seasonOffset=0]

function PodiumGetScoreIsForUser(_index, _leaderboardName, _range, _seasonOffset = 0)
{
    if (_index < 0) return false;
    var _scoresData = PodiumGetScores(_leaderboardName, _range, _seasonOffset, PODIUM_PRIORITY_NO_REQUEST);
    if (_index >= array_length(_scoresData)) return false;
    
    return (_scoresData[_index].userID == PodiumGetUserID());
}