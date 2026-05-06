/// Returns the number of days since the reference date, as set by `PODIUM_REFERENCE_DATE`. This
/// function forces the UTC timezone and further returns a whole number of days where `0` indicates
/// that the current day is the same as the reference date.
/// 
/// You may also specify a modulo, which must be a positive integer, to wrap day values around.
/// This is helpful to hack together a season system if a particular platform doesn't support
/// historic scores.
/// 
/// N.B. If the current date is before the reference date then this function will return `0`.
/// 
/// @param [modulo]
/// @param [dayOffset=0]
/// @param [hourOffset=0]

function PodiumGetDays(_modulo = undefined, _dayOffset = 0, _hourOffset = 0)
{
    var _time = PodiumGetTime();
    
    if (PODIUM_REFERENCE_DATE > _time)
    {
        var _days = 0;
    }
    else
    {
        _time = date_inc_day(_time, _dayOffset);
        _time = date_inc_hour(_time, _hourOffset);
        var _days = floor(date_day_span(PODIUM_REFERENCE_DATE, _time));
    }
    
    if (is_numeric(_modulo))
    {
        _modulo = floor(_modulo);
        
        if (_modulo > 0)
        {
            _days = (_days + 1_000*_modulo) mod _modulo;
        }
    }
    
    return _days;
}