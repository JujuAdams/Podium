/// @param leaderboardName
/// @param value
/// @param [priority=normal]

function PodiumSubmit(_leaderboardName, _value, _priority = PODIUM_PRIORITY_NORMAL)
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
    
    var _struct = new __PodiumClassSubmit(_leaderboardName, _value);
    
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
    
    return _struct;
}