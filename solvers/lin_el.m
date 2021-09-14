function Result = lin_el(Topo, Material)
    Result = struct();
    
    if strcmp(Topo.ftype, 'surface')
        Topo.f = integrateF(Topo);
    end
    
    K = stiffK(Topo, Material);

    K = setboundsK(K, Topo.x0);
    u = K\Topo.f;
    u = reshape(u, [Topo.dim, Topo.totn])';
    x = Topo.x + u;
    Result.u = u;
    Result.x = x;
    Result.K = K;
end