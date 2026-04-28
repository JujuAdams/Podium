function PodiumGetUserSignedIn()
{
    static _system = __PodiumSystem();
    
    if (PODIUM_ON_SWITCH)
    {
        return ((_system.__switchNPLNUserHandle != undefined) && (_system.__switchNPLNUserHandle > 0));
    }
    else
    {
        return false;
    }
}