gdk_update();
psn_tick();
steam_update();

var _playFabLoggedIn = PodiumGetPlayFabLoggedIn();
if (playFabLoggedIn != _playFabLoggedIn)
{
    playFabLoggedIn = _playFabLoggedIn;
    
    if (_playFabLoggedIn)
    {
        //PodiumLbGetScores("testLeaderboard");
        //PodiumLbGetScores("testHourlyLeaderboard");
        //PodiumLbGetScores("testDailyLeaderboard");
        
        PodiumLbGetScores("testLeaderboard");
        PodiumLbGetScores("testLeaderboard", PODIUM_RANGE_FRIENDS);
        PodiumLbGetScores("testLeaderboard", PODIUM_RANGE_AROUND);
    }
}

var _i = 0;
repeat(gamepad_get_device_count())
{
    if (gamepad_button_check_pressed(_i, gp_face1))
    {
        show_debug_message($"Found input from gamepad {_i}");
        
        gamepad = _i;
        PodiumSetPSGamepad(_i);
        PodiumSetXboxUser(xboxone_user_for_pad(_i));
    }
    
    ++_i;
}

if (keyboard_check_pressed(ord("E")) || gamepad_button_check_pressed(gamepad, gp_start))
{
    var _data = PodiumExportLocalData();
    
    var _string = json_stringify(_data);
    var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _string);
    buffer_save(_buffer, "podium.json");
    buffer_delete(_buffer);
    
    show_debug_message("Saved `podium.json`");
}

if (keyboard_check_pressed(ord("I")) || gamepad_button_check_pressed(gamepad, gp_select))
{
    if (not file_exists("podium.json"))
    {
        show_debug_message("`podium.json` does not exist");
    }
    else
    {
        var _buffer = buffer_load("podium.json");
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        PodiumImportLocalData(json_parse(_string));
    }
}