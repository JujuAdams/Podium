/// Returns a struct containing the state of locally stored achievements.

function PodiumExportLocalData()
{
    static _system = __PodiumSystem();
    
    _system.__localChanged = false;
    
    if (_system.__local)
    {
        //TODO - Add basic encryption
        return variable_clone(_system.__localData);
    }
    else
    {
        if (PODIUM_RUNNING_FROM_IDE)
        {
            __PodiumTrace("Cannot export, not using locally stored data");
        }
        
        return {};
    }
}