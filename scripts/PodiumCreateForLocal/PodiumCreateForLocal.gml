/// Creates a leaderboard for use with Podium.
/// 
/// N.B. This function must only be called in `__PodiumDefinitionsLocal()`.
/// 
/// @param name
/// @param higherValueIsBetter

function PodiumCreateForLocal(_name, _higherValueIsBetter)
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
        __PodiumError("`PodiumCreateGeneral()` must only be called in a `__PodiumDefinitions*` script");
    }
    
    if (PODIUM_VERBOSE)
    {
        __PodiumTrace($"Defining leaderboard \"{_name}\", higherValueIsBetter = {_higherValueIsBetter? "true" : "false"}");
    }
    
    _leaderboardDict[$ _name] = new __PodiumClassLeaderboard({
        __ref:                 _name,
        __higherValueIsBetter: _higherValueIsBetter,
    });
}