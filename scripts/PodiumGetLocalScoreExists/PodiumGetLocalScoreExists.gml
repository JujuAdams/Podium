/// @param leaderboardName

function PodiumGetLocalScoreExists(_leaderboardName)
{
    static _system = __PodiumSystem();
    
    var _offlineRecord = _system.__localData[$ _leaderboardName];
    if (_offlineRecord == undefined)
    {
        return false;
    }
    
    var _leaderboardStruct = __PodiumLeaderboardFind(_leaderboardName);
    if (_leaderboardStruct == undefined)
    {
        return false;
    }
    
    return _leaderboardStruct.__GetOfflineRecordValid(_offlineRecord);
}