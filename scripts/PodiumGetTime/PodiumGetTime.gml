function PodiumGetTime()
{
    __PODIUM_PUSH_UTC
    
    var _time = date_current_datetime();
    
    __PODIUM_POP_UTC
    return _time;
}