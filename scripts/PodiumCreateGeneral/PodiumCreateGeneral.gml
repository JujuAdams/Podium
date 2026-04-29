/// This function creates a leaderboard for use with Podium.
/// 
/// N.B. You must not call this function in the following definition functions:
///      - `__PodiumDefinitionsLocal()`
///      - `__PodiumDefinitionsSteam()`
///      - `__PodiumDefinitionsSwitch()`
///      - `__PodiumDefinitionsPlayFab()`
///      Instead, please call the platform-specific version of `PodiumCreateGeneral()` in those
///      definition functions.
/// 
/// Exactly what the `serviceRef` is depends on the platform. Please refer to platform/SDK
/// documentation for official information. However, the following is a brief guide:
/// 
/// Local Data:
///   `serviceRef` is a string. This will be used to store the state of the leaderboard when
///   exporting/importing JSON with Podium functions.
/// 
/// PlayStation:
///   `serviceRef` is an integer that is the index of the leaderboard, as set in the backend.
/// 
/// Xbox / Windows GDK (native):
///   `serviceRef` is a string that is the stat identifier, as set in the backend.
/// 
/// iOS / GameCenter:
///   `serviceRef` is a string that is the leaderboard identifier, as set in the GameCenter
///   backend.
/// 
/// Android / Google Play Services:
///   `serviceRef` is a string that is the leaderboard identifier, as set in the Google Play
///   Services backend.
///
/// @param name
/// @param serviceRef

function PodiumCreateGeneral(_name, _serviceRef)
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
        __PodiumTrace($"Defining leaderboard \"{_name}\" for service reference `{_serviceRef}`");
    }
    
    _leaderboardDict[$ _name] = new __PodiumClassLeaderboard({
        __ref: _serviceRef,
    });
}