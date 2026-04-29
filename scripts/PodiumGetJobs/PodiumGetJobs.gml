function PodiumGetJobs()
{
    static _system = __PodiumSystem();
    return (array_length(_system.__pendingArray) + array_length(_system.__queuedArray));
}