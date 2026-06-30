/// @param inputString

function __PodiumMetadataUnpack(_inputString)
{
    static _result = {};
    
    if (string_length(_inputString) < 2)
    {
        _result.__scoreVersion = undefined;
        _result.__metadataString = _inputString;
        return _result;
    }
    
    if (string_char_at(_inputString, 1) != "#")
    {
        _result.__scoreVersion = undefined;
        _result.__metadataString = _inputString;
        return _result;
    }
    
    var _pos = string_pos_ext("#", _inputString, 2);
    if (_pos < 2)
    {
        _result.__scoreVersion = undefined;
        _result.__metadataString = _inputString;
        return _result;
    }
    
    _result.__scoreVersion = string_copy(_inputString, 2, _pos - 2);
    _result.__metadataString = string_delete(_inputString, 1, _pos);
    return _result;
}