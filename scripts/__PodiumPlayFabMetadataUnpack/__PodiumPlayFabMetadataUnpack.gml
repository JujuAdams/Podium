/// @param inputString

function __PodiumPlayFabMetadataUnpack(_inputString)
{
    static _result = {};
    
    if (string_length(_inputString) < 2)
    {
        _result.__xboxUser = undefined;
        _result.__metadataString = _inputString;
        return _result;
    }
    
    if (string_char_at(_inputString, 1) != "%")
    {
        _result.__xboxUser = undefined;
        _result.__metadataString = _inputString;
        return _result;
    }
    
    var _pos = string_pos_ext("%", _inputString, 2);
    if (_pos < 2)
    {
        _result.__xboxUser = undefined;
        _result.__metadataString = _inputString;
        return _result;
    }
    
    var _xboxUser = undefined;
    try
    {
        _xboxUser = int64($"0x{string_copy(_inputString, 2, _pos - 2)}");
    }
    catch(_error)
    {
        show_debug_message(_error);
        __PodiumWarning("Could not convert metadata substring into user ID");
    }
    
    if (PODIUM_XBOX_USER_CIPHER == undefined)
    {
        __PodiumError("Please set `PODIUM_XBOX_USER_CIPHER` to an unsigned 64-bit integer\nThis is a number in the format of `0x0000_0000_0000_0000`");
    }
    
    if (PODIUM_XBOX_USER_CIPHER == 0x0000_0000_0000_0000)
    {
        __PodiumError("Cipher cannot literally be `0x0000_0000_0000_0000`. Choose another random number");
    }
    
    _result.__xboxUser = _xboxUser ^ PODIUM_XBOX_USER_CIPHER;
    _result.__metadataString = string_delete(_inputString, 1, _pos);
    return _result;
}