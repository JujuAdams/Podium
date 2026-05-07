var _string = $"Podium {PODIUM_VERSION}, {PODIUM_DATE}\n";
_string += $"Gamepad = {gamepad} (press gp_face1 to choose gamepad)\n";
_string += $"\n";
_string += $"User signed in = {PodiumGetSignedIn()? "true" : "false"}\n";
_string += $"Sign in state = {PodiumGetSignedInState()}\n";
_string += $"User ID = \"{PodiumGetUserID()}\"\n";
_string += $"Username = \"{PodiumGetUserName()}\"\n";
_string += $"Busy = {PodiumGetBusy()? "true" : "false"}\n";
_string += $"Jobs = {PodiumGetJobs()}\n";
_string += $"\n";
_string += $"\"all time score\" score = {json_stringify(PodiumGetScores("all time score", PODIUM_RANGE_TOP), true)}\n";

draw_set_font(fntConsolas);
draw_text(10, 10, _string);