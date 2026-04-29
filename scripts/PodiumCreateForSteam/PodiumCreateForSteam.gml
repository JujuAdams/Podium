/// Creates a leaderboard for use with Podium.
/// 
/// N.B. This function must only be called in `__PodiumDefinitionsSteam()`.
/// 
/// `serviceRef` is a string that is the name of the leaderboard, as set in the Steamworks backend.
/// `sortMethod` should be one of the `lb_sort_*` constants. `displayType` should be one of the
/// `lb_disp_*` constants.
/// 
/// @param name
/// @param serviceRef
/// @param sortMethod
/// @param displayType
/// @param [refreshPeriod=never]

function PodiumCreateForSteam(_name, _serviceRef, _sortMethod, _displayType, _refreshPeriod = PODIUM_REFRESH_NEVER)
{
    static _system = __PodiumSystem();
    static _leaderboardDict = _system.__leaderboardDict;
    
    if (struct_exists(_leaderboardDict, _name))
    {
        if (PODIUM_RUNNING_FROM_IDE)
        {
            __PodiumError($"Overwriting leaderboard \"{_name}\" (service reference \"{_serviceRef}\"). Please ensure that `PodiumCreateGeneral()` is called once and once only per leaderboard name");
        }
        
        return;
    }
    
    if (not _system.__runningDefinitions)
    {
        __PodiumError("`PodiumCreateGeneral()` must only be called in a `__PodiumDefinitions*` script");
    }
    
    if (PODIUM_VERBOSE)
    {
        __PodiumTrace($"Defining leaderboard \"{_name}\" for service reference `{_serviceRef}`, _sortMethod = {_sortMethod}, displayType = {_displayType}, refreshPeriod = {_refreshPeriod}");
    }
    
    _leaderboardDict[$ _name] = new __PodiumClassLeaderboard({
        __ref:           _serviceRef,
        __formattedRef:  undefined,
        __sortMethod:    _sortMethod,
        __displayType:   _displayType,
        __refreshPeriod: _refreshPeriod,
    });
}