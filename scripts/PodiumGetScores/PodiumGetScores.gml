/// N.B. You must call `PodiumSetPSGamepad()` or `PodiumSetXboxUser()` before getting scores from
///      leaderboards on PlayStation or Xbox.
/// 
/// N.B. Podium does not call `steam_update()` for you when using Steam. You must call this function
///      yourself.
/// 
/// N.B. Podium does not call `psn_tick()` or `psn_init_leaderboard()` for you when running on
///      PlayStation. You must call these functions yourself.
/// 
/// N.B. Podium does not call `gdk_init()`, `gdk_update()`, or `gdk_quit()` for you when running on
///      Xbox. You must call these functions yourself.
///
/// @param leaderboardName
/// @param [range=top]
/// @param [priority=normal]

function PodiumGetScores(_leaderboardName, _range = PODIUM_RANGE_TOP, _priority = PODIUM_PRIORITY_NORMAL)
{
    static _system = __PodiumSystem();
    static _queuedArray = _system.__queuedArray;
    
    if (not PodiumGetUserSignedIn())
    {
        __PodiumSoftError($"User not signed in:\n- On Switch, call `PodiumSetSwitchNPLNUserHandle()`\n- On PlayStation 5, call `PodiumSetPSGamepad()`\n- On Xbox, call `PodiumSetXboxUser()`");
        return undefined;
    }
    
    if ((_range != PODIUM_RANGE_TOP) && (_range != PODIUM_RANGE_FRIENDS) && (_range != PODIUM_RANGE_AROUND) && (_range != __PODIUM_RANGE_USER))
    {
        __PodiumSoftError($"Unhandled range `{_range}`");
        return undefined;
    }
    
    var _leaderboardStruct = __PodiumLeaderboardFind(_leaderboardName);
    if (_leaderboardStruct == undefined)
    {
        __PodiumSoftError($"Leaderboard name \"{_leaderboardName}\" not recognised");
        return undefined;
    }
    
    if (_leaderboardStruct.__GetCachedScores(_range))
    {
        return _leaderboardStruct.__GetScoresData(_range);
    }
    else
    {
        var _struct = new __PodiumClassGetScores(_leaderboardStruct, _range);
        
        if (not __PodiumGetUniqueOperation(_struct))
        {
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Discarding GET_SCORES operation {string(ptr(self))} as an identical operation is queued or pending");
            }
        }
        else
        {
            if (_priority == PODIUM_PRIORITY_HIGH)
            {
                array_insert(_queuedArray, _struct, 0);
            }
            else if (_priority == PODIUM_PRIORITY_IMMEDIATE)
            {
                _struct.__Dispatch();
            }
            else
            {
                array_push(_queuedArray, _struct);
            }
        }
        
        return undefined;
    }
}