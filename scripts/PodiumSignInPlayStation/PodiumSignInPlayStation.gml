/// @param gamepad
/// @param [showOSDialog=true]

function PodiumSignInPlayStation(_gamepad = -1, _showOSDialog = true)
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
            __psUserID  = undefined;
            __username  = (_gamepad < 0)? undefined : psn_name_for_pad(_gamepad);
            
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
            
            var _result = psn_check_np_availability(__psGamepad, _showOSDialog);
            
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"PSN availability returned {_result}");
            }
            
            if (_result < 0)
            {
                call_later(10, time_source_units_frames, function()
                {
                    __signInState = PODIUM_USER_SIGN_IN_FAILED;
                });
            }
            else
            {
                __psNPAvailabilityAsyncID = _result;
            }
        }
    }
}