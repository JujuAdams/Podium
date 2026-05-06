function PodiumGetUserName()
{
    static _system = __PodiumSystem();
    return _system.__username ?? _system.__usernameHint;
}