/// @param userHandle

function PodiumGetSwitchAccountIndex(_userHandle)
{
    static _system = __PodiumSystem();
    
    return _system.__switchAccountIndex;
}