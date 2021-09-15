function Result = euler_mx2(Topo, Material, Numerical, Result)
    save = Numerical.save;
    dt   = Numerical.dt;
    eta  = Material.eta(1);
    
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
        
    K = stiffK(Topo, Material);
    K = setboundsK(K, Topo.x0);
    Bvec = linveBmx(Topo);
        
    u_0     = Topo.u;
    if any(u_0)==0
        fprintf("No initial strain \n")
        sigma_0 = Bvec' \ Topo.f; 
    else
        fprintf("Initial strain \n")
        sigma_0 = D*Bvec*Topo.u; % Compute it either from elasticity or viscosity ?
        
    end
    
    sigma_k = sigma_0;
    u_k     = u_0;
    
    Result.sigmas  = zeros(Numerical.n_incr/save, 3);
    Result.times = zeros(1,Numerical.n_incr/save);
    c = 0;
    t = 0;
    fdot = zeros(size(Topo.f));
    
    for it = 1:Numerical.n_incr
        
        
        str_e_kp1 = Bvec'*D \ (dt*fdot - str_e_k);
        str_v_kp1 = Bvec'\(dt*f/eta-Bvec'*str_v_k);
        str_kp1 = str_e_kp1 + str_v_kp1;
        sigma_kp1 = D*(str_kp1-str_k)-dt*sigma_k/eta + sigma_k;
        
        if mod(it,save) == 0
            c = c + 1;
            Result.sigmas(c,:)  = sigma_k;
            Result.times(c) = t;
        end 
        sigma_k = sigma_kp1
        u_k     = u_kp1
%         norm(u_k)
    end
    Result.sigma_0  = sigma_0;
    Result.tau = eta/(Material.E(1)/(1-Material.nu(1)^2));
    Result.strain_0 = Bvec*Topo.u;
    Result.x = Topo.X + reshape(Topo.u, [2,4])';
end
%         sigma_m = Bvec'*D*sigma_k/eta;
%         sigma_m(Topo.fixdof) = 0;
%         u_kp1     = K \ (dt*fdot + dt*sigma_m + K*u_k);
%         sigma_kp1 = (eye(size(D))-D*dt/eta)*sigma_k+D*Bvec*(u_kp1-u_k);
%         t = t + dt;      
