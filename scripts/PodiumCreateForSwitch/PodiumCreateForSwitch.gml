/// Creates a leaderboard for use with Podium.
/// 
/// N.B. This function must only be called in `__PodiumDefinitionsSwitch()`.
/// 
/// `categoryTypeName` is a string that is the name of a leaderboard category, as set in the
/// Nintendo NPLN backend. `categoryID` is a number that identifies unique leaderboards, also found
/// in the NPLN backend.
/// 
/// @param name
/// @param categoryTypeName
/// @param categoryID

function PodiumCreateForSwitch(_name, _categoryTypeName, _categoryID)
{
    static _system = __PodiumSystem();
    static _leaderboardDict = _system.__leaderboardDict;
    
    if (struct_exists(_leaderboardDict, _name))
    {
        if (PODIUM_RUNNING_FROM_IDE)
        {
            __PodiumError($"Overwriting leaderboard \"{_name}\". Please ensure that `PodiumCreateForSwitch()` is called once and once only per leaderboard name");
        }
        
        return;
    }
    
    if (not _system.__runningDefinitions)
    {
        __PodiumError("`PodiumCreateForSwitch()` must only be called in a `__PodiumDefinitions*` script");
    }
    
    if (PODIUM_VERBOSE)
    {
        __PodiumTrace($"Defining leaderboard \"{_name}\" for category name \"{_categoryTypeName}\" / category ID {_categoryID}");
    }
    
    _leaderboardDict[$ _name] = new __PodiumClassLeaderboard({
        __ref:              $"{_categoryTypeName}_{_categoryID}",
        __categoryTypeName: _categoryTypeName,
        __categoryID:       _categoryID,
    });
}