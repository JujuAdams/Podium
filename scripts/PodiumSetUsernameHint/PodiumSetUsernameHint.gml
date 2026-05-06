/// @param username

function PodiumSetUsernameHint(_username)
{
    static _system = __PodiumSystem();
    _system.__usernameHint = _username;
}