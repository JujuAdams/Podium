/// Whether to report lots of information messages to the console. This can be helpful to diagnose
/// problems. You will likely want to set this macro to `false` for production builds.
#macro PODIUM_VERBOSE  (PODIUM_RUNNING_FROM_IDE)

#macro PODIUM_WARNINGS_HAVE_CALLSTACKS  true

/// Whether to force use of local data storage. This will ignore any remote or per-platform
/// services.
#macro PODIUM_FORCE_LOCAL_DATA  false

#macro PODIUM_LB_DISRESPECT_RATE_LIMITS  false

///////
// PlayFab
///////

//You must tick the "Allow client to post player statistics" box in the PlayFab backend. This can
//be found in the product / Settings / API Features.
#macro PODIUM_GDK_USES_PLAYFAB_LEADERBOARDS  true

//Found on PlayFab backend
#macro PODIUM_PLAYFAB_TITLE_ID  ""

//Found on PlayFab backend in the product / Settings / Secret Keys
#macro PODIUM_PLAYFAB_TITLE_SECRET  ""