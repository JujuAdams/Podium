function __PodiumLocalSubmitAllPending()
{
    static _system = __PodiumSystem();
    
    var _localData = _system.__localData;
    var _namesArray = struct_get_names(_localData);
    var _i = 0;
    repeat(array_length(_namesArray))
    {
        var _name = _namesArray[_i];
        var _offlineRecord = _localData[$ _name];
        
        if (not PodiumGetLeaderboardExists(_name))
        {
            __PodiumWarning($"Found a score for leaderboard \"{_name}\" but that leaderboard doesn't exist");
        }
        else
        {
            if (_offlineRecord.__pending)
            {
                var _leaderboardStruct = __PodiumLeaderboardFind(_name);
                if (_leaderboardStruct != undefined)
                {
                    if (_leaderboardStruct.__GetOfflineRecordValid(_offlineRecord))
                    {
                        PodiumSubmit(_name, _offlineRecord.__value, _offlineRecord.__metadata);
                    }
                    else
                    {
                        __PodiumTrace($"Removing old score for leaderboard \"{_name}\"");
                        struct_remove(_localData, _name);
                    }
                }
            }
        }
        
        ++_i;
    }
}