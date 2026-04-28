/// Whether to report lots of information messages to the console. This can be helpful to diagnose
/// problems. You will likely want to set this macro to `false` for production builds.
#macro PODIUM_VERBOSE  true

#macro PODIUM_VERBOSE_ASYNC  true

#macro PODIUM_WARNINGS_HAVE_CALLSTACKS  true

/// Whether to force use of local data storage. This will ignore any remote or per-platform
/// services.
#macro PODIUM_FORCE_LOCAL_DATA  false

// Dangerous! Only set this to `true` if you need it
#macro PODIUM_DISRESPECT_RATE_LIMITS  false

///////
// Platform-specific
///////

#macro PODIUM_PSN_LEADERBOARD_SERVICE_LABEL  undefined

// Nintendo Switch tenant ID. Please remember to remove the environment identifier at the end e.g.
// if the tenant ID is `"t-01234567-xyz"` then use `"t-01234567"`.

///////
// PlayFab
///////

//You must tick the "Allow client to post player statistics" box in the PlayFab backend. This can
//be found in the product / Settings / API Features.
#macro PODIUM_GDK_USES_PLAYFAB_LEADERBOARDS  false

//Found on PlayFab backend
#macro PODIUM_PLAYFAB_TITLE_ID  ""

//Found on PlayFab backend in the product / Settings / Secret Keys
#macro PODIUM_PLAYFAB_TITLE_SECRET  ""