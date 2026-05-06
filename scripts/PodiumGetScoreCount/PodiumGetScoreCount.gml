/// @param leaderboardName
/// @param range
/// @param [seasonOffset=0]

function PodiumGetScoreCount(_leaderboardName, _range, _seasonOffset = 0)
{
    var _scoresData = PodiumGetScores(_leaderboardName, _range, _seasonOffset, PODIUM_PRIORITY_NO_REQUEST);
    return is_array(_scoresData)? array_length(_scoresData) : 0;
}