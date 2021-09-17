function Result = euler_kv(Geom, Mat, Set, Result)
    
    if strcmp(Set.euler_type, 'forward')
        fprintf("Solving for Forward Euler's with dt = %f \n", Set.dt);
    elseif strcmp(Set.euler_type, 'backward')
        fprintf("Solving for Backward Euler's with dt = %f \n", Set.dt);
    end
    
    K = stiffK(Geom, Mat, Set);
    Btot = linveB(Geom, Set);
    
    E = Mat.P(1);
    nu = Mat.P(2);
        D  = E/(1-nu^2) ... 
      *[  1  nu     0
          nu   1     0
          0   0  (1-nu)/2 ];  
    
    save = Set.save;
    dt   = Set.dt;
    eta  = Mat.visco;
    
    Result.strs  = zeros(Set.time_incr/save, 3);
    Result.times = zeros(1,Set.time_incr/save);
    c = 0;
    t = 0;
    uk = zeros(size(Geom.x(:)));
    Geom.f = integrateF(Geom, Set);

    for it = 1:Set.time_incr
        
        if strcmpi(Set.euler_type, 'forward')
            stepMatrix = Btot-(dt/eta)*K;
            stepMatrix = setboundsK(stepMatrix, Geom.x0);
            Btotbc = setboundsK(Btot, Geom.x0);
            ukp1 = Btotbc\(stepMatrix*uk+Geom.f*(dt/eta));
        elseif strcmpi(Set.euler_type, 'backward')
            stepMatrix = K+eta*Btot/dt;
            stepMatrix = setboundsK(stepMatrix, Geom.x0);
            Btotbc = setboundsK(Btot, Geom.x0);
            ukp1 = stepMatrix\(Geom.f+Btotbc*uk*eta/dt);
        end
        
        t = t + dt;      
        
        if mod(it,save) == 0
            c = c + 1;
            urs = reshape(uk, [Geom.dim,Geom.n_nodes])';
            urskp1 = reshape(ukp1, [Geom.dim,Geom.n_nodes])';
            
            [stress, strain, k] = totStressStr2(urs, urskp1, Geom, Mat, Set);
            Result.strs(c,:)  = strain;
            Result.times(c) = t;
        end 
        uk = ukp1;
    end
    Result.sigma_0 = stress;
    Result.tau = eta/(Mat.P(1)/(1-Mat.P(2)^2))*ones(size(strain));
    Result.k = k;
    Result.str_inf = stress/(Mat.P(1)*(1+Mat.P(2))/(1-Mat.P(2)^2));
    Result.str_inf = D \ stress;
    Result.str_inf = Result.str_inf(1);
    Result.K = K;
    Result.u = uk;
    Result.x = Geom.x + reshape(ukp1, [Geom.dim,Geom.n_nodes])';
end
