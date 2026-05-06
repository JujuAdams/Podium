/// @param leaderboardName
/// @param value
/// @param metadataString
/// @param pending

function __PodiumStoreOfflineRecord(_leaderboardName, _value, _metadataString, _pending)
{
    static _system = __PodiumSystem();
    
    var _offlineRecord = _system.__offlineRecordDict[$ _leaderboardName];
    if (not is_struct(_offlineRecord))
    {
        _offlineRecord = new __PodiumClassOfflineRecord(_value, _metadataString, PodiumGetTime(), _pending);
        _system.__offlineRecordDict[$ _leaderboardName] = _offlineRecord;
    }
    else
    {
        var _leaderboardStruct = __PodiumLeaderboardFind(_leaderboardName);
        if (not is_struct(_leaderboardStruct))
        {
            //Unknown leaderboard requirements. We'll use the most recent score
            var _betterScore = (_value != _offlineRecord.__value);
        }
        else
        {
            if (_leaderboardStruct.__serviceData.descending)
            {
                var _betterScore = (_value > _offlineRecord.__value);
            }
            else
            {
                var _betterScore = (_value < _offlineRecord.__value);
            }
        }
        
        if (_betterScore)
        {
            _system.__localChanged = true;
            
            _offlineRecord.__value    = _value;
            _offlineRecord.__metadata = _metadataString;
            _offlineRecord.__datetime = PodiumGetTime();
            _offlineRecord.__pending  = _pending;
        }
    }
}