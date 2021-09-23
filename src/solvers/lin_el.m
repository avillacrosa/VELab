function Result = lin_el(Geo, Mat, Set, Result)
    K = stiffK(Geo, Mat, Set);
    K = setboundsK(K, Geo);
    u = K\Geo.f;
    u = reshape(u, [Geo.dim, Geo.n_nodes])';
    x = Geo.x + u;
    Result.u = u;
    Result.x = x;
    Result.K = K;
end