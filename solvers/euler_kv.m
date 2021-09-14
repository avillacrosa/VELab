function Result = euler_kv(Topo, Material, Numerical, Result)
    
    if strcmp(Numerical.euler_type, 'forward')
        fprintf("Solving for Forward Euler's with dt = %f \n", Numerical.dt);
    elseif strcmp(Numerical.euler_type, 'backward')
        fprintf("Solving for Backward Euler's with dt = %f \n", Numerical.dt);
    end
    
    K = stiffK(Topo, Material);
    Btot = linveB(Topo);
    
    % TODO Save this as arguments...
    save = Numerical.save;
    dt   = Numerical.dt;
    eta  = Material.eta(1);
    
    Result.strs  = zeros(Numerical.n_incr/save, 3);
    Result.times = zeros(1,Numerical.n_incr/save);
    c = 0;
    t = 0;
    uk = zeros(size(Topo.x(:)));
    Topo.f = integrateF(Topo);
    
    for it = 1:Numerical.n_incr
        
        if strcmp(Numerical.euler_type, 'forward')
            stepMatrix = Btot-(dt/eta)*K;
            stepMatrix = setboundsK(stepMatrix, Topo.x0);
            Btotbc = setboundsK(Btot, Topo.x0);
            ukp1 = Btotbc\(stepMatrix*uk+Topo.f*(dt/eta));
        elseif strcmp(Numerical.euler_type, 'backward')
            stepMatrix = K+eta*Btot/dt;
            stepMatrix = setboundsK(stepMatrix, Topo.x0);
            Btotbc = setboundsK(Btot, Topo.x0);
            ukp1 = stepMatrix\(Topo.f+Btotbc*uk*eta/dt);
        end
        
        t = t + dt;      
        
        if mod(it,save) == 0
            c = c + 1;
            urs = reshape(uk, [2,4])';
            urskp1 = reshape(ukp1, [2,4])';
            
            [stress, strain, k] = totStressStr2(urs, urskp1, Topo, Material, dt);
            Result.strs(c,:)  = strain;
            Result.times(c) = t;
        end 
        uk = ukp1;
    end
    Result.sigma_0 = stress;
    
    Result.tau = eta/(Material.E(1)/1-Material.nu(1)^2)*ones(size(strain));
    Result.k = k;
    Result.str_inf = stress/(Material.E(1)/1-Material.nu(1)^2);
    Result.K = K;
    Result.u = uk;
    Result.x = Topo.x + reshape(ukp1, [Topo.dim,Topo.totn])';
end
