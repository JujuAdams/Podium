/// Returns the day of the week as an integer from `0` to `6`:
/// 
/// | Day       | Value |
/// |-----------|-------|
/// | Sunday    |  `0`  |
/// | Monday    |  `1`  |
/// | Tuesday   |  `2`  |
/// | Wednesday |  `3`  |
/// | Thursday  |  `4`  |
/// | Friday    |  `5`  |
/// | Saturday  |  `6`  |
/// 
/// @param [offset=0]

PodiumGetWeekday();

function PodiumGetWeekday(_offset = 0)
{
    var _time = PodiumGetTime();
    _time = date_inc_day(_time, floor(_offset));
    return date_get_weekday(_time);
}