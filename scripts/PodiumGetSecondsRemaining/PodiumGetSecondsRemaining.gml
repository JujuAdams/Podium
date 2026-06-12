function PodiumGetSecondsRemaining()
{
    __PODIUM_PUSH_UTC
    
	var _return = date_second_span(date_current_datetime(), PodiumGetDailyDate(+1));
    
    __PODIUM_POP_UTC
    return _return;
}