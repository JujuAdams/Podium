/// @param nickname

function PodiumSetSwitchNickname(_nickname)
{
    static _system = __PodiumSystem();
    
    if (not PODIUM_ON_SWITCH)
    {
        return;
    }
    
    with(_system)
    {
        if (__switchNickname != _nickname)
        {
            __switchNickname = _nickname;
            __PodiumSwitchTryCompleteLogin(false);
        }
    }
}