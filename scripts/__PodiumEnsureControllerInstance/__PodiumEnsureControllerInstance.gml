function __PodiumEnsureControllerInstance()
{
    static _created = false;
    
    if (not _created)
    {
        _created = true;
        instance_create_depth(0, 0, 0, __PodiumController);
        
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            __PodiumEnsureControllerInstance();
        },
        [], -1));
    }
    else
    {
        if (not instance_exists(__PodiumController))
        {
            __PodiumError("`__PodiumController` has been destroyed or deactivated");
        }
        else if (not __PodiumController.persistent)
        {
            __PodiumError("`__PodiumController` has been set to not persistent");
        }
    }
}