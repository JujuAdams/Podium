function __PodiumSoftError(_string)
{
    if (PODIUM_RUNNING_FROM_IDE)
    {
        __PodiumError(_string);
    }
    else
    {
        __PodiumWarning(_string);
    }
}