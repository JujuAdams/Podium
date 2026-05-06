function __PodiumGlobalClearRemoteCaches()
{
    static _system = __PodiumSystem();
    
    if (PODIUM_VERBOSE)
    {
        __PodiumWarning("Clearning all caches");
    }
    
    with(_system)
    {
        var _leaderboardDict = __leaderboardDict;
        var _namesArray = struct_get_names(_leaderboardDict);
        var _i = 0;
        repeat(array_length(_namesArray))
        {
            PodiumClearRemoteCache(_namesArray[_i]);
            ++_i;
        }
    }
}