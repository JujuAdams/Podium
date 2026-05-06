function PodiumGetPlayStationGamepad()
{
    static _system = __PodiumSystem();
    return _system.__psGamepad;
}