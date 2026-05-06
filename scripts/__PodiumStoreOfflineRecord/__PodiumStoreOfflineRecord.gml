/// @param leaderboardName
/// @param value
/// @param metadataString

function __PodiumStoreOfflineRecord(_leaderboardName, _value, _metadataString)
{
    static _system = __PodiumSystem();
    
    var _pending = not PodiumGetOfflineOnly();
    
    var _offlineRecord = _system.__offlineRecordDict[$ _leaderboardName];
    if (not is_struct(_offlineRecord))
    {
        _offlineRecord = new __PodiumClassOfflineRecord(_value, _metadataString, PodiumGetTime(), _pending);
        _system.__offlineRecordDict[$ _leaderboardName] = _offlineRecord;
    }
    else if ((_offlineRecord.__value != _value) || (_offlineRecord.__pending != _pending)) //TODO - Choose higher or lower depending on leaderboard
    {
        _system.__localChanged = true;
        
        _offlineRecord.__value    = _value;
        _offlineRecord.__metadata = _metadataString;
        _offlineRecord.__datetime = PodiumGetTime();
        _offlineRecord.__pending  = _pending;
    }
}