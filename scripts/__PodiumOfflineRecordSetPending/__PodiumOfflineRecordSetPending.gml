/// @param leaderboardName
/// @param pending

function __PodiumOfflineRecordSetPending(_leaderboardName, _pending)
{
    static _system = __PodiumSystem();
    
    var _struct = _system.__offlineRecordDict[$ _leaderboardName];
    if (not is_struct(_struct))
    {
        __PodiumWarning($"Trying set offline score pending to {_pending? "true" : "false"} but leaderboard \"{_leaderboardName}\" doesn't have a offline score");
    }
    else
    {
        if (_struct.__pending != _pending)
        {
            _struct.__pending = _pending;
            _system.__localChanged = true;
        }
    }
}