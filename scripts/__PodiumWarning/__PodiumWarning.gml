function __PodiumWarning(_string)
{
    _string = $"Warning! {string_replace_all(_string, "\n", " ")}";
    
    if (PODIUM_WARNINGS_HAVE_CALLSTACKS)
    {
        _string += $"          {debug_get_callstack()}";
    }
    
    __PodiumTrace(_string);
}