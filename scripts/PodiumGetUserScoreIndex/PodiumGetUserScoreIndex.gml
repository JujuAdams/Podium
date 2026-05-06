/// @param leaderboardName
/// @param range
/// @param [seasonOffset=0]

function PodiumGetUserScoreIndex(_leaderboardName, _range, _seasonOffset = 0)
{
    var _localUserID = PodiumGetUserID();
    
    var _scoresData = PodiumGetScores(_leaderboardName, _range, _seasonOffset, PODIUM_PRIORITY_NO_REQUEST);
    var _i = 0;
    repeat(array_length(_scoresData))
    {
        if (_scoresData[_i].userID == _localUserID)
        {
            return _i;
        }
        
        ++_i;
    }
    
    return -1;
}