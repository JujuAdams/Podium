function __PodiumGetUniqueOperation(_opStruct)
{
    static _pendingArray = __PodiumSystem().__pendingArray;
    static _queuedArray  = __PodiumSystem().__queuedArray;
    
    var _i = 0;
    repeat(array_length(_queuedArray))
    {
        if (_queuedArray[_i].__OperationEqual(_opStruct))
        {
            return false;
        }
        
        ++_i;
    }
    
    var _i = 0;
    repeat(array_length(_pendingArray))
    {
        if (_pendingArray[_i].__OperationEqual(_opStruct))
        {
            return false;
        }
        
        ++_i;
    }
    
    return true;
}