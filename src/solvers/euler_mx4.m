function Result = euler_mx4(Topo, Material, Numerical, Result)
    
    if strcmp(Numerical.euler_type, 'forward')
        fprintf("Solving for Forward Euler's with dt = %f \n", Numerical.dt);
    elseif strcmp(Numerical.euler_type, 'backward')
        fprintf("Solving for Backward Euler's with dt = %f \n", Numerical.dt);
    end
    
    E = Material.E(1);
    nu = Material.nu(1);
    D  = E/(1-nu^2) ... 
      *[  1  nu     0
          nu   1     0
          0   0  (1-nu)/2 ];  
    
    Bvec = linveBmx(Topo);
    sigma_0 = D*Bvec*Topo.u;
    sigma_k = sigma_0;
    
    save = Numerical.save;
    dt   = Numerical.dt;
    eta  = Material.eta(1);
    
    Result.sigmas  = zeros(Numerical.n_incr/save, 3);
    Result.times = zeros(1,Numerical.n_incr/save);
    c = 0;
    t = 0;
    
    for it = 1:Numerical.n_incr
        
        if strcmp(Numerical.euler_type, 'forward')
            sigma_kp1 = (eye(size(D))-dt*D/eta)*sigma_k;
        elseif strcmp(Numerical.euler_type, 'backward')
            sigma_kp1 = (eye(size(D))+dt*D/eta) \ sigma_k; 
        end
        
        t = t + dt;      
        
        if mod(it,save) == 0
            c = c + 1;
            Result.sigmas(c,:)  = sigma_k;
            Result.times(c) = t;
        end 
        sigma_k = sigma_kp1;
    end
    Result.sigma_0  = sigma_0;
    Result.tau = eta/(Material.E(1)/(1-Material.nu(1)^2));
    Result.strain_0 = Bvec*Topo.u;
    Result.x = Topo.X + reshape(Topo.u, [2,4])';
end
