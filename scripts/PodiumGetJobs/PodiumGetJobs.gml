function PodiumGetJobs()
{
    static _system = __PodiumSystem();
    return (array_length(_system.__pendingArray)
          + array_length(_system.__queuedSubmitArray)
          + array_length(_system.__queuedFetchArray));
}