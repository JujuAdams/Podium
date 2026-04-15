/// @param leaderboardName
/// @param value

function PodiumPush(_leaderboardName, _value)
{
    with(PodiumFind(_leaderboardName))
    {
        Push(_value);
    }
}