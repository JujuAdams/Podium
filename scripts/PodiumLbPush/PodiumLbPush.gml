/// @param leaderboardName
/// @param value

function PodiumLbPush(_leaderboardName, _value)
{
    with(PodiumLbFind(_leaderboardName))
    {
        Push(_value);
    }
}