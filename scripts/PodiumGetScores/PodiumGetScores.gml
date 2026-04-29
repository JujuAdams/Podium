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
    
    //if (SPARKLE_ON_GDK)
    //{
    //    if (_system.__xboxUser == 0)
    //    {
    //        __SparkleError($"Xbox user is invalid ({_system.__xboxUser})");
    //    }
    //}
    //
    ////For some reason, the Windows GDK extension doesn't allow you to check if a user is signed in 
    //if (SPARKLE_ON_XBOX)
    //{
    //    if (not xboxone_user_is_signed_in(_system.__xboxUser))
    //    {
    //        __SparkleTrace($"Warning! Xbox user {_system.__xboxUser} is not signed in");
    //    }
    //}
    //
    //if (SPARKLE_ON_PS_ANY && (__psGamepadIndex < 0))
    //{
    //    __SparkleError($"Gamepad index is invalid ({__psGamepadIndex})");
    //}
    
    if ((_range != PODIUM_RANGE_TOP) && (_range != PODIUM_RANGE_FRIENDS) && (_range != PODIUM_RANGE_AROUND))
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
    
    if (_leaderboardStruct.__GetCached(_range))
    {
        return _leaderboardStruct.__GetData(_range);
    }
    else
    {
        var _struct = new __PodiumClassGetScores(_leaderboardName, _range);
        
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
        
        return undefined;
    }
}