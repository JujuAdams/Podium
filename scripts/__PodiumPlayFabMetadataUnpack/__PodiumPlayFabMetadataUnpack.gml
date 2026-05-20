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
    
    var _xboxUser = string_copy(_inputString, 2, _pos - 2);
    var _metadataString = string_delete(_inputString, 1, _pos);
    
    _result.__xboxUser = _xboxUser;
    _result.__metadataString = _metadataString;
    return _result;
}