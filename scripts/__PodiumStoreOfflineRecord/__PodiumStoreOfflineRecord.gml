/// @param leaderboardName
/// @param value
/// @param metadataString
/// @param pending

function __PodiumStoreOfflineRecord(_leaderboardName, _value, _metadataString, _pending)
{
    static _system = __PodiumSystem();
    
    var _betterScore = false;
    
    var _offlineRecord = _system.__offlineRecordDict[$ _leaderboardName];
    if (not is_struct(_offlineRecord))
    {
        _offlineRecord = new __PodiumClassOfflineRecord(_value, _metadataString, PodiumGetTime(), _pending);
        _system.__offlineRecordDict[$ _leaderboardName] = _offlineRecord;
        _betterScore = true;
    }
    else
    {
        var _betterScore = __PodiumGetBetterThanOffline(_leaderboardName, _value);
        if (_betterScore)
        {
            with(_offlineRecord)
            {
                __value    = _value;
                __metadata = _metadataString;
                __datetime = PodiumGetTime();
                __pending  = _pending;
            }
        }
    }
    
    if (_betterScore)
    {
        _system.__localChanged = true;
    }
    
    return _betterScore;
}