/// @param userHandle

function PodiumSetSwitchNPLNUserHandle(_userHandle)
{
    static _system = __PodiumSystem();
    
    _system.__switchNPLNUserHandle = _userHandle;
}