/// @param leaderboardName
/// @param value

function __PodiumGetBetterThanOffline(_leaderboardName, _value)
{
    static _system = __PodiumSystem();
    
    var _offlineRecord = _system.__offlineRecordDict[$ _leaderboardName];
    if (not is_struct(_offlineRecord))
    {
        return true;
    }
    else
    {
        var _leaderboardStruct = __PodiumLeaderboardFind(_leaderboardName);
        if (not is_struct(_leaderboardStruct))
        {
            //Unknown leaderboard requirements. We'll use the most recent score
            return (_value != _offlineRecord.__value);
        }
        else if (_leaderboardStruct.__serviceData.overwrite)
        {
            return (_value != _offlineRecord.__value);
        }
        else if (_leaderboardStruct.__serviceData.descending)
        {
            return (_value > _offlineRecord.__value);
        }
        else
        {
            return (_value < _offlineRecord.__value);
        }
    }
    
    //Should never get here
    return true;
}