/// Sets the gamepad for the user that has unlocked a trophy. You should call this function at
/// least once before calling `PodiumAward()`.
/// 
/// When running on PlayStation, this function will call `psn_init_trophy()` for you.
/// 
/// @param gamepad

function PodiumSetPSGamepad(_gamepad)
{
    static _system = __PodiumSystem();
    
    if (PODIUM_ON_PS5)
    {
        psn_init_trophy(_gamepad);
        _system.__psGamepad = _gamepad;
        
        if (PODIUM_VERBOSE)
        {
            __PodiumTrace($"Set PlayStation gamepad to {_gamepad}");
        }
    }
}