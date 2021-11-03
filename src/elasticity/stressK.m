function K = stressK(x, Geo, Mat, Set)
    if Set.sparse
        K = stressKsp(x, Geo, Mat, Set);
    else
        K = stressKfl(x, Geo, Mat, Set);
    end
end