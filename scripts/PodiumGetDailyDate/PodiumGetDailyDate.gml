/// @param [dayOffset=0]

function PodiumGetDailyDate(_dayOffset = 0)
{
    __PODIUM_PUSH_UTC
    
	var _return = date_inc_day(PODIUM_REFERENCE_DATE, PodiumGetDays(undefined, _dayOffset));
    
    __PODIUM_POP_UTC
    return _return;
}