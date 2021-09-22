function Result = lin_el(Geom, Mat, Set, Result)
    K = stiffK(Geom, Mat, Set);
    K = setboundsK(K, Geom);
    u = K\Geom.f;
    u = reshape(u, [Geom.dim, Geom.n_nodes])';
    x = Geom.x + u;
    Result.u = u;
    Result.x = x;
    Result.K = K;
end