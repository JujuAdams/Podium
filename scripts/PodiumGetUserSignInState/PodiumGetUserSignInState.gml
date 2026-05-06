function PodiumGetUserSignInState()
{
    static _system = __PodiumSystem();
    
    return _system.__signInState;
}