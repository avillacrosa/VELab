%--------------------------------------------------------------------------
% Solve a maxwell linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function Result = euler_mx(Geo, Mat, Set, Result)
    save = Set.save;
    dt   = Set.dt;
    eta  = Mat.visco;

    if strcmpi(Set.euler_type, 'forward')
        fprintf("> Solving for Forward Euler's with dt = %f \n", dt);
    elseif strcmpi(Set.euler_type, 'backward')
        fprintf("> Solving for Backward Euler's with dt = %f \n", dt);
    end
    
    % For venant, D depends on deformation which depends on integral ???
%     [~, c] = material(Geo.x, Geo.X, ones(1,Geo.dim), Mat);
%     D = constD(c);
%     D = [134.6153   57.6923          0
%            57.6923  134.6153         0
%                  0         0   38.4615];
    D = [ 134.6153   57.6923   57.6923  0  0  0
           57.6923  134.6153   57.6923  0  0  0 
           57.6923   57.6923  134.6153  0  0  0
              0          0         0  38.4615     0  0
              0          0         0    0 38.4615    0
              0          0         0    0  0 38.4615];
    
    % Get integrals at equilibrium
    Bvec = linveBmx(Geo, Set); % Integral of B.
    Btot = linveB(Geo, Set); % Integral of B'*B. 
    Btot = setboundsK(Btot, Geo);

    K = stiffK(Geo, Mat, Set);
    K = setboundsK(K, Geo);
    
    u_0     = Geo.u; % If this is 0 but f is not -> Ct. stress, inf strain
    u_0     = u_0';
    u_0     = u_0(:);
    f_0     = Geo.f; % If this is 0 but u is not -> Ct. strain, stress -> 0
    
    if any(u_0) == 1 % u_0 != 0, f_0 = 0
        fprintf("> Sudden strain \n")
        u_v_0   = zeros(size(u_0));
        u_e_0   = u_0 - u_v_0;
        sigma_0 = D*Bvec*u_e_0; 
    else % u_0 = 0, f_0 != 0
        fprintf("> Sudden stress  \n")
        u_e_0   = zeros(size(u_0));
        u_v_0   = zeros(size(u_0));
        sigma_0 = Bvec' \ f_0; 
    end

    u_k     = u_0;
    u_v_k   = u_v_0;
    u_e_k   = u_e_0;
    sigma_k = sigma_0;
    
    fdot = zeros(size(f_0));
    
    Result.sigmas  = zeros(Set.time_incr/save, Geo.vect_dim);
    Result.us  = zeros(Set.time_incr/save, Geo.dim*Geo.n_nodes);
    Result.times = zeros(1,Set.time_incr/save);
    c = 1;
    t = 0;
    for it = 1:Set.time_incr
        % K, Btot and Bvec are global
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
            c = c + 1;
        end
    end
    Result.sigma_0  = sigma_0;
    Result.tau = eta/(Mat.P(1)/(1-Mat.P(2)^2));
    Result.strain_0 = Bvec*u_0;
    Result.x = Geo.X + reshape(u_k, [Geo.dim,Geo.n_nodes])';
end   
