/// @param leaderboardName
/// @param [reuseStruct=false]

function PodiumGetLocalScore(_leaderboardName, _reuseStruct = false)
{
    static _system = __PodiumSystem();
    
    var _offlineRecord = _system.__localData[$ _leaderboardName];
    if (_offlineRecord == undefined)
    {
        return undefined;
    }
    
    var _leaderboardStruct = __PodiumLeaderboardFind(_leaderboardName);
    if (_leaderboardStruct == undefined)
    {
        return undefined;
    }
    
    if (not _leaderboardStruct.__GetOfflineRecordValid(_offlineRecord))
    {
        __PodiumTrace($"Removing old score for leaderboard \"{_leaderboardName}\"");
        struct_remove(_system.__localData, _leaderboardName);
        return undefined;
    }
    
    if (_reuseStruct)
    {
        var _result = new __PodiumClassRecord(PodiumGetUserName(), 0, PODIUM_UNKNOWN_RANK, PodiumGetUserID(), "", true);
    }
    else
    {
        static _resultStatic = new __PodiumClassRecord(PodiumGetUserName(), 0, PODIUM_UNKNOWN_RANK, PodiumGetUserID(), "", true);
        var _result = _resultStatic;
    }
    
    with(_result)
    {
        name           = PodiumGetUserName();
        value          = _offlineRecord.__value;
        rank           = PODIUM_UNKNOWN_RANK;
        userID         = PodiumGetUserID();
        metadataString = _offlineRecord.__metadata;
        local          = true;
    }
    
    return _result;
}