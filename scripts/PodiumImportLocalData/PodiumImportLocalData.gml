/// Sets the state of locally stored achievements from a struct. The struct should have been
/// created by `PodiumLocalExport()`.
/// 
/// @param data

function PodiumImportLocalData(_data)
{
    static _system = __PodiumSystem();
    
    _system.__localChanged = false;
    
    if (_system.__local)
    {
        //TODO - Add basic encryption
        _system.__localData = variable_clone(_data);
    }
    else
    {
        if (PODIUM_RUNNING_FROM_IDE)
        {
            __PodiumWarning("Cannot import, not using locally stored data");
        }
    }
}