function Result = euler_mx(Geom, Mat, Set, Result)
    save = Set.save;
    dt   = Set.dt;
    eta  = Mat.visco;

    if strcmpi(Set.euler_type, 'forward')
        fprintf("Solving for Forward Euler's with dt = %f \n", dt);
    elseif strcmpi(Set.euler_type, 'backward')
        fprintf("Solving for Backward Euler's with dt = %f \n", dt);
    end
    
    %TODO FIXIT HARDCODE
    E = Mat.P(1);
    nu = Mat.P(2);
    D  = E/(1-nu^2) ... 
      *[  1  nu     0
          nu   1     0
          0   0  (1-nu)/2 ];  
      
    % Get integrals at equilibrium
    Bvec = linveBmx(Geom, Set); % Integral of B.
    Btot = linveB(Geom, Set); % Integral of B'*B. 

    K = stiffK(Geom, Mat, Set);
    K = setboundsK(K, Geom.x0);

    u_0     = Geom.u; % If this is 0 but f is not -> Ct. stress, inf strain
    f_0     = Geom.f; % If this is 0 but u is not -> Ct. strain, stress -> 0
    
    if any(u_0) == 1 % u_0 != 0, f_0 = 0
        fprintf("------Sudden strain------ \n")
        u_v_0   = zeros(size(u_0));
        u_e_0   = u_0 - u_v_0;
        sigma_0 = D*Bvec*u_e_0; % 22
    else % u_0 = 0, f_0 != 0
        fprintf("------Sudden stress------ \n")
        u_e_0   = zeros(size(u_0));
        u_v_0   = zeros(size(u_0));
        sigma_0 = Bvec' \ f_0; % 10
    end

    u_k     = u_0;
    u_v_k   = u_v_0;
    u_e_k   = u_e_0;
    sigma_k = sigma_0;
    
    fdot = zeros(size(f_0));
    
    Result.sigmas  = zeros(Set.time_incr/save, 3);
    Result.us  = zeros(Set.time_incr/save, Geom.dim*Geom.n_nodes);
    Result.times = zeros(1,Set.time_incr/save);
    c = 1;
    t = 0;
    size(u_0), size(Btot)
    for it = 1:Set.time_incr
        Btot = setboundsK(Btot, Geom.x0);

        u_v_kp1 = Btot \ (Btot*u_v_k + f_0*dt/eta);
        u_e_kp1 = K \ (dt*fdot + K*u_e_k);
        u_kp1 = u_v_kp1 + u_e_kp1;
        sigma_kp1 = (eye(size(D)) - dt*D/eta)*sigma_k+ D*Bvec*(u_kp1-u_k);
        
        u_k     = u_kp1;
        sigma_k = sigma_kp1;
        u_e_k   = u_e_kp1;
        u_v_k   = u_v_kp1;
        t = t + dt;
        if mod(it,save) == 0
            fprintf("it = %4i, |u| = %f, stress_x = %f \n", ...
                it, norm(u_k),  sigma_k(1));

            Result.sigmas(c,:) = sigma_k;
            Result.us(c,:) = u_k;
            Result.times(c) = t;
            c = c+1;
        end
    end
    Result.sigma_0  = sigma_0;
    Result.tau = eta/(Mat.P(1)/(1-Mat.P(2)^2));
    Result.strain_0 = Bvec*Geom.u;
    Result.x = Geom.X + reshape(u_k, [Geom.dim,Geom.n_nodes])';
end   
