function K = constK(x, Geo, Mat, Set)
    if Set.sparse
        K = constKsp(x, Geo, Mat, Set);
    else
        K = constKfl(x, Geo, Mat, Set);
    end
end