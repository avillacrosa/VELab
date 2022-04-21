function [Geo, Mat, Set, Result] = initializeData(Geo, Mat, Set)
    [Geo.X, Geo.n, Geo.na] = meshgen(Geo.ns, Geo.ds);
    [Geo, Mat, Set]        = completeDefault(Geo, Mat, Set);
    [Geo, Mat, Set]        = completeData(Geo, Mat, Set);

    Set    = initializeOutFolder(Set);
    Result = initializeOutData(Geo, Mat, Set);
end