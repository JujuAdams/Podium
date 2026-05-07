// Feather disable all

function __PodiumPlayServicesDecode(_inString)
{
    static _inBufferStatic  = buffer_create(1024, buffer_grow, 1);
    static _outBufferStatic = buffer_create(1024, buffer_grow, 1);
    
    static _hexStatic = (function()
    {
        var _array = array_create(256, 0);
        
        _array[ord("A")] = 10;
        _array[ord("B")] = 11;
        _array[ord("C")] = 12;
        _array[ord("D")] = 13;
        _array[ord("E")] = 14;
        _array[ord("F")] = 15;
        
        _array[ord("a")] = 10;
        _array[ord("b")] = 11;
        _array[ord("c")] = 12;
        _array[ord("d")] = 13;
        _array[ord("e")] = 14;
        _array[ord("f")] = 15;
        
        _array[ord("0")] = 0;
        _array[ord("1")] = 1;
        _array[ord("2")] = 2;
        _array[ord("3")] = 3;
        _array[ord("4")] = 4;
        _array[ord("5")] = 5;
        _array[ord("6")] = 6;
        _array[ord("7")] = 7;
        _array[ord("8")] = 8;
        _array[ord("9")] = 9;
        
        return _array;
    })();
    
    var _inBuffer   = _inBufferStatic;
    var _outBuffer  = _outBufferStatic;
    var _hexArray   = _hexStatic;
    
    buffer_seek(_inBuffer, buffer_seek_start, 0);
    buffer_write(_inBuffer, buffer_text, _inString);
    var _length = buffer_tell(_inBuffer);
    
    buffer_seek(_inBuffer, buffer_seek_start, 0);
    buffer_seek(_outBuffer, buffer_seek_start, 0);
    
    var _i = 0;
    while(_i < _length)
    {
        var _byte = buffer_read(_inBuffer, buffer_u8);
        ++_i;
        
        if (_byte == 0x7e) //Tilde
        {
            if (_i > _length-2)
            {
                //Unexpected end of data
                break;
            }
            
            var _hexHigh = _hexArray[buffer_read(_inBuffer, buffer_u8)];
            var _hexLow  = _hexArray[buffer_read(_inBuffer, buffer_u8)];
            _i += 2;
            
            buffer_write(_outBuffer, buffer_u8, _hexLow | (_hexHigh << 4));
        }
        else
        {
            buffer_write(_outBuffer, buffer_u8, _byte);
        }
    }
    
    buffer_write(_outBuffer, buffer_u8, 0);
    buffer_seek(_outBuffer, buffer_seek_start, 0);
    
    return buffer_read(_outBuffer, buffer_string);
}