/// @param name
/// @param statisticName
/// @param leaderboardName

function PodiumCreateForPlayFab(_name, _statisticName, _leaderboardName)
{
    static _system = __PodiumSystem();
    static _leaderboardDict = _system.__leaderboardDict;
    
    if (struct_exists(_leaderboardDict, _name))
    {
        if (PODIUM_RUNNING_FROM_IDE)
        {
            __PodiumError($"Overwriting leaderboard \"{_name}\". Please ensure that `PodiumCreateGeneral()` is called once and once only per leaderboard name");
        }
        
        return;
    }
    
    if (not _system.__runningDefinitions)
    {
        __PodiumError("`PodiumCreateForPlayFab()` must only be called in `__PodiumDefinitionsPlayFab()`");
    }
    
    if (PODIUM_VERBOSE)
    {
        __PodiumTrace($"Defining leaderboard \"{_name}\" for service statistic `{_statisticName}` / leaderboard = {_leaderboardName}");
    }
    
    _leaderboardDict[$ _name] = new __PodiumClassLeaderboard({
        __ref:             $"{_statisticName}_{_leaderboardName}",
        __statisticName:   _statisticName,
        __leaderboardName: _leaderboardName,
    });
}