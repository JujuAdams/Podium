/// Whether to report lots of information messages to the console. This can be helpful to diagnose
/// problems. You will likely want to set this macro to `false` for production builds.
#macro PODIUM_VERBOSE  false

#macro PODIUM_VERBOSE_ASYNC  false

#macro PODIUM_UNKNOWN_RANK  "?"

#macro PODIUM_WARNINGS_HAVE_CALLSTACKS  true

#macro PODIUM_REFERENCE_DATE  date_create_datetime(2026, 1, 1, 0, 0, 0)

/// Whether to force use of local data storage. This will ignore any remote or per-platform
/// services.
#macro PODIUM_FORCE_LOCAL_DATA  false

#macro PODIUM_DEBUG_DAY_OFFSET  0

#macro PODIUM_DEBUG_IGNORE_LOCAL_IMPORT  false

#macro PODIUM_PSN_LEADERBOARD_SERVICE_LABEL  undefined

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