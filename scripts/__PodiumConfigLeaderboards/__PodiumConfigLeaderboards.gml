function __PodiumConfigLeaderboards()
{
    PodiumCreate({
        leaderboardName: "all time score",
        
        steam: {
            serviceName: "testBestScore",
            displayType: lb_disp_numeric,
        },
        
        playFab: "testDescending",
    });
    
    PodiumCreate({
        leaderboardName: "best time",
        
        steam: {
            serviceName: "testBestTime",
            displayType: lb_disp_time_sec,
        },
        
        playFab: "testAscending",
    });
    
    PodiumCreate({
        leaderboardName: "daily challenge",
        daily: true,
        
        steam: {
            serviceName: "testDaily",
            displayType: lb_disp_numeric,
        },
        
        playFab: "testDaily",
    });
    
    //PodiumCreate({
    //    leaderboardName: "daily",
    //    descending: true, //descending = higher is better
    //    daily: false,
    //    hasWeeklyHistory: true,
    //    steam: {
    //        serviceName: "test",
    //        displayType: lb_disp_numeric,
    //    },
    //    switch: {
    //        categoryTypeName: "testDaily#",
    //        categoryID: 0,
    //    },
    //    playStation: [0, 1, 2, 3, 4, 5, 6],
    //    playFab: "testDaily",
    //    playServices: "",
    //    gameCenter: "",
    //});
}