/// Gets the current gamepad that Podium will target when unlocking achievements.

function PodiumGetXboxUser()
{
    static _system = __PodiumSystem();
    return _system.__xboxUser;
}