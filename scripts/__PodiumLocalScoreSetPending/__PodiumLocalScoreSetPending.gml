/// @param leaderboardName
/// @param pending

function __PodiumLocalScoreSetPending(_leaderboardName, _pending)
{
    static _system = __PodiumSystem();
    
    var _struct = _system.__localData[$ _leaderboardName];
    if (not is_struct(_struct))
    {
        __PodiumWarning($"Trying set local score pending to {_pending? "true" : "false"} but leaderboard \"{_leaderboardName}\" doesn't have a local score");
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