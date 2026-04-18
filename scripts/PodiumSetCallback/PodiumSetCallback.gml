/// Sets a callback that is executed whenever a call to `PodiumGetScores()` or `PodiumRefresh()`
/// completes. You may specify a different callback for different ranges amd a callback will only
/// be executed when the leaderboard with that specific range is updated. You may set a callback
/// to `undefined` to not execute any function when a leaderboard range is updated.
/// 
/// Setting a callback will overwrite the previous callback without executing the previous
/// callback. If `PodiumGetScores()` or `PodiumRefresh()` hit a rate limit (which happens a lot in
/// my experience) then the callback will be executed immediately with whatever state has been
/// cached.
/// 
/// The callback is executed with six parameters:
/// 
/// argument0:
///   The name of the leaderboard.
/// 
/// argument1:
///   The range for the returned scores. This will be one of the `PODIUM_RANGE_*` constants.
/// 
/// argument2:
///   The rankings array (as returned by `PodiumGetScores()`). If
/// 
/// argument3:
///   The status of the refresh request. This will be one of the `PODIUM_STATUS_*` constants. It
///   is possible for the status to be `PODIUM_STATUS_CANCELLED` if the callback is replaced by a
///   new callback set by calling this function again or by calling `PodiumGetScores()` with a
///   callback.
/// 
/// argument4:
///   Whether a cached value has been returned, usually because the leaderboard is rate limited and
///   on cooldown.
/// 
/// argument5:
///   The metadata provided when calling `PodiumRefresh()`.

function PodiumSetCallback(_leaderboardName, _callback = undefined, _callbackMetadata = undefined, _range = PODIUM_RANGE_TOP)
{
    with(PodiumFind(_leaderboardName))
    {
        SetCallback(_range, _callback, _callbackMetadata);
    }
}