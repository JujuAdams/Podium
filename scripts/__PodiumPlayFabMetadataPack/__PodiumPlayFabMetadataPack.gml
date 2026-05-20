/// @param xboxUser
/// @param metadataString

function __PodiumPlayFabMetadataPack(_xboxUser, _metadataString)
{
    if (PODIUM_XBOX_USER_CIPHER == undefined)
    {
        __PodiumError("Please set `PODIUM_XBOX_USER_CIPHER` to an unsigned 64-bit integer\nThis is a number in the format of `0x0000_0000_0000_0000`");
    }
    
    if (PODIUM_XBOX_USER_CIPHER == 0x0000_0000_0000_0000)
    {
        __PodiumError("Cipher cannot literally be `0x0000_0000_0000_0000`. Choose another random number");
    }
    
    return $"%{ptr(int64(_xboxUser) ^ PODIUM_XBOX_USER_CIPHER)}%{_metadataString}";
}