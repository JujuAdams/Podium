function PodiumGetOfflineOnly()
{
    static _system = __PodiumSystem();
    return _system.__offlineOnly;
}