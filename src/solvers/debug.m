function Result = debug(Geo, Set, Mat, Result)
    initStress(Geo.X+Geo.u, Geo, Mat, Set)
end