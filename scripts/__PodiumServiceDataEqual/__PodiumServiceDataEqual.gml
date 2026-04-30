/// @param serviceDataA
/// @param serviceDataB

function __PodiumServiceDataEqual(_a, _b)
{
    //Faster to do this than to iterate over an array generated at runtime
    return ((_a[$ "__ref"                ] == _b[$ "__ref"                ])
         && (_a[$ "__formattedRef"       ] == _b[$ "__formattedRef"       ])
         && (_a[$ "__higherValueIsBetter"] == _b[$ "__higherValueIsBetter"])
         && (_a[$ "__formattedRef"       ] == _b[$ "__formattedRef"       ])
         && (_a[$ "__sortMethod"         ] == _b[$ "__sortMethod"         ])
         && (_a[$ "__displayType"        ] == _b[$ "__displayType"        ])
         && (_a[$ "__refreshPeriod"      ] == _b[$ "__refreshPeriod"      ])
         && (_a[$ "__statisticName"      ] == _b[$ "__statisticName"      ])
         && (_a[$ "__leaderboardName"    ] == _b[$ "__leaderboardName"    ])
         && (_a[$ "__categoryTypeName"   ] == _b[$ "__categoryTypeName"   ])
         && (_a[$ "__categoryID"         ] == _b[$ "__categoryID"         ]));
}