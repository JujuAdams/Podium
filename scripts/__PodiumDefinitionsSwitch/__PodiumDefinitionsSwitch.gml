function __PodiumDefinitionsSwitch()
{
    //You will need to add a category type in the Config page in the NPLN backend.
    
    PodiumCreate("all time score",   { categoryTypeName: "testDescending", categoryID: 0 });
    PodiumCreate("best time",        { categoryTypeName: "testAscending",  categoryID: 0 }, false);
    PodiumCreate("daily challenge",  { categoryTypeName: "testDaily",      categoryID: 0 }, undefined, undefined, PODIUM_REFRESH_DAILY);
}