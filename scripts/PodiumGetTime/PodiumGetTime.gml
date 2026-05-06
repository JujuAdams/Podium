function PodiumGetTime()
{
    var _time = date_current_datetime();
    
    if (PODIUM_RUNNING_FROM_IDE)
    {
        _time = date_inc_day(_time, PODIUM_DEBUG_DAY_OFFSET);
    }
    
    return _time;
}