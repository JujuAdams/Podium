/// Returns whether the state of locally stored achievements has changed. If this function returns
/// `true` then you should save achievements data using `PodiumExportLocalData()`.

function PodiumGetLocalDataChanged()
{
    static _system = __PodiumSystem();
    return _system.__localChanged;
}