function __PodiumGetUniqueOperation(_opStruct)
{
    static _pendingArray      = __PodiumSystem().__pendingArray;
    static _queuedSubmitArray = __PodiumSystem().__queuedSubmitArray;
    static _queuedFetchArray = __PodiumSystem().__queuedFetchArray;
    
    var _i = 0;
    repeat(array_length(_queuedSubmitArray))
    {
        if (_queuedSubmitArray[_i].__OperationEqual(_opStruct))
        {
            return false;
        }
        
        ++_i;
    }
    
    var _i = 0;
    repeat(array_length(_queuedFetchArray))
    {
        if (_queuedFetchArray[_i].__OperationEqual(_opStruct))
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