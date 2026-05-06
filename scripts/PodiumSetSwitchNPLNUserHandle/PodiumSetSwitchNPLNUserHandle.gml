/// @param userHandle

function PodiumSetSwitchNPLNUserHandle(_userHandle)
{
    static _system = __PodiumSystem();
    
    if (PODIUM_ON_SWITCH)
    {
        with(_system)
        {
            var _oldSignedIn = PodiumGetUserSignedIn();
            
            __switchNPLNUserHandle = is_struct(_userHandle)? _userHandle : 0;
            
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Set Switch user handle to {ptr(_userHandle)}");
            }
            
            __PodiumSwitchTryCompleteLogin(_oldSignedIn);
        }
    }
}