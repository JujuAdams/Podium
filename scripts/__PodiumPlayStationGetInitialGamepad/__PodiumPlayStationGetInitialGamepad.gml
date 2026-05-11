function __PodiumPlayStationGetInitialGamepad()
{
    var _initialUser = psn_default_user();
    var _i = 0;
    repeat(gamepad_get_device_count())
    {
        var _padUser = psn_user_for_pad(_i);
        if (_padUser == _initialUser)
        {
            return _i;
        }
        
        ++_i;
    }
    
    return -1;
}