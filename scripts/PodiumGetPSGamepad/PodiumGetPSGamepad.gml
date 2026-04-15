/// Gets the current gamepad that Podium will target when unlocking trophies.

function PodiumGetPSGamepad()
{
    static _system = __PodiumSystem();
    return _system.__psGamepad;
}