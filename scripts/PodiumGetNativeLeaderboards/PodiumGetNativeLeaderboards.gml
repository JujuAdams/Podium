/// Returns whether this platform + service configuration has a native leaderboard feature that
/// can be used to display leaderboards in the OS.

function PodiumGetNativeLeaderboards()
{
    return PODIUM_USING_PLAY_SERVICES;
}