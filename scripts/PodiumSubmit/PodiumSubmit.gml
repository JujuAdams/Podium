/// @param leaderboardName
/// @param value
/// @param [priority=normal]

function PodiumSubmit(_leaderboardName, _value, _priority = PODIUM_PRIORITY_NORMAL)
{
    static _system = __PodiumSystem();
    static _queuedArray = _system.__queuedArray;
    
    if (not PodiumGetUserSignedIn())
    {
        __PodiumSoftError($"User not signed in:\n- On Switch, call `PodiumSetSwitchNPLNUserHandle()`\n- On PlayStation 5, call `PodiumSetPSGamepad()`\n- On Xbox & Windows GDK, call `PodiumSetXboxUser()`");
        return undefined;
    }
    
    var _leaderboardStruct = __PodiumLeaderboardFind(_leaderboardName);
    if (is_struct(_leaderboardStruct))
    {
        var _struct = new __PodiumClassSubmit(_leaderboardStruct.__GetFormattedServiceData(), _value);
        
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
}