/// @param displayName
/// @param value
/// @param rank
/// @param userID
/// @param metadataString
/// @param offline

function __PodiumClassRecord(_displayName, _value, _rank, _userID, _metadataString, _offline) constructor
{
    var _metadataUnpacked = __PodiumMetadataUnpack(_metadataString);
    
    name           = _displayName;
    value          = _value;
    rank           = _rank;
    userID         = _userID;
    metadataString = _metadataUnpacked.__metadataString;
    offline        = _offline; //Whether the score is from the local offline cache
    scoreVersion   = _metadataUnpacked.__scoreVersion;
    
    ////////////////////////////////////////////
    // DO NOT ADD METHODS TO THIS CONSTRUCTOR //
    ////////////////////////////////////////////
}