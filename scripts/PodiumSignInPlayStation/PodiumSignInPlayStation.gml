/// @param gamepad

function PodiumSignInPlayStation(_gamepad = -1)
{
    static _system = __PodiumSystem();
    
    if (PODIUM_ON_PS5)
    {
        with(_system)
        {
            if ((_gamepad >= 0) && (__signInState == PODIUM_USER_SIGNED_IN))
            {
                __PodiumWarning("A user is already signed in");
                return;
            }
            
            __psGamepad = _gamepad;
            __username = (_gamepad < 0)? undefined : psn_name_for_pad(_gamepad);
            
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Set PlayStation gamepad to {_gamepad} \"{__username}\"");
            }
            
            __PodiumGlobalClearRemoteCaches();
            
            if (_gamepad < 0)
            {
                __signInState = PODIUM_USER_SIGNED_OUT;
                return;
            }
            
            __signInState = PODIUM_USER_SIGNING_IN;
            
            psn_init_trophy(_gamepad);
            
            call_later(1, time_source_units_frames, function()
            {
                __PodiumUserSignedIn();
            });
        }
    }
}