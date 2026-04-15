/// @param userHandle

function PodiumGetSwitchNPLNUserHandle(_userHandle)
{
    static _system = __PodiumSystem();
    
    return _system.__switchNPLNUserHandle;
}