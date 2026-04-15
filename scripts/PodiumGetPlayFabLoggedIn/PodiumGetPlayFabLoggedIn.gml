function PodiumGetPlayFabLoggedIn()
{
    static _system = __PodiumSystem();
    
    return _system.__playFabLoggedIn;
}