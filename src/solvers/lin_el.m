function Result = lin_el(Geom, Mat, Set, Result)
    K = stiffK(Geom, Mat, Set);

    K = setboundsK(K, Geom.x0);
    Geom.f, Geom.x
    u = K\Geom.f;
    u = reshape(u, [Geom.dim, Geom.n_nodes])';
    x = Geom.x + u;
    Result.u = u;
    Result.x = x;
    Result.K = K;
end