var _string = $"Podium {PODIUM_VERSION}, {PODIUM_DATE}\n";
_string += $"Gamepad = {gamepad} (press gp_face1 to choose gamepad)\n";
_string += $"\n";
_string += $"Using local data = {PodiumGetUsingLocal()? "true" : "false"}\n";

if (PodiumGetUsingLocal())
{
    _string += $"Local changed = {PodiumGetLocalDataChanged()? "true" : "false"}\n";
}

_string += $"\n";

if (PodiumGetUsingLocal())
{
    _string += $"[E] / [start]  = Export local data\n";
    _string += $"[I] / [select] = Import local data\n";
    _string += $"\n";
}

draw_set_font(fntConsolas);
draw_text(10, 10, _string);