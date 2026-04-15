/// Returns whether the state of locally stored achievements has changed. If this function returns
/// `true` then you should save achievements data using `PodiumLocalExport()`.

function PodiumGetLocalDataChanged()
{
    static _system = __PodiumSystem();
    return (_system.__local && _system.__localChanged);
}