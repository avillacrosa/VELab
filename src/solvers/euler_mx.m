%--------------------------------------------------------------------------
% Solve a maxwell linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function Result = euler_mx(Geo, Mat, Set, Result)
    save = fix(Set.time_incr/Set.n_saves);
    dt   = Set.dt;
    eta  = Mat.visco;

    if strcmpi(Set.euler_type, 'forward')
        fprintf("> Solving for Forward Euler's with dt = %f \n", dt);
    elseif strcmpi(Set.euler_type, 'backward')
        fprintf("> Solving for Backward Euler's with dt = %f \n", dt);
    end
    
    % For venant, D depends on deformation which depends on integral ???
    [~, c] = material(Geo.x(Geo.n(1,:),:), Geo.X(Geo.n(1,:),:), ones(1,Geo.dim), Mat);
    D = constD(c);
    
    % Get integrals at equilibrium
    Bvec = intB(Geo, Set);    % Integral of B.
    Btot = intBB(Geo, Set);   % Integral of B'*B. 
    
    u_0     = vec_nvec(Geo.u); % If this is 0 but f is not -> Ct. stress, inf strain
    f_0     = Geo.f; % If this is 0 but u is not -> Ct. strain, stress -> 0
    fdot = zeros(size(f_0));

    if any(u_0) == 1 % u_0 != 0, f_0 = 0
        fprintf("> Sudden strain \n")
        u_v_0   = zeros(size(u_0));
        u_e_0   = u_0 - u_v_0;
        sigma_0 = D*Bvec*u_e_0; 
    else % u_0 = 0, f_0 != 0
        fprintf("> Sudden stress  \n")
        u_e_0   = zeros(size(u_0));
        u_v_0   = zeros(size(u_0));
        sigma_0 = zeros(Geo.dim, Geo.dim);
        fmat  = ref_nvec(Geo.f, Geo.n_nodes, Geo.dim);
        for an = 1:Geo.n_nodes
            if any(fmat(an,:))
                % TODO FIXIT only for squares I think, + not normalized
%                 xn = Geo.x(an,:)/norm(Geo.x(an,:));
                xn = Geo.x(an,:);
                xn(xn~=0) = 1;
                sigma_0 = sigma_0 + xn\fmat(an,:);
            end
        end
    end
    sigma_0 = vec_mat(sigma_0);

    u_k     = u_0;
    u_kp1   = u_k;
    u_v_k   = u_v_0;
    u_v_kp1 = u_v_k;
    u_e_k   = u_e_0;
    u_e_kp1 = u_v_k;
    
    sigma_k = sigma_0;
    
    Result.sigmas  = zeros(Set.time_incr/save, Geo.vect_dim);
    Result.xt = zeros(Set.n_saves, size(Geo.x,1), size(Geo.x,2));
    Result.ut = zeros(Set.n_saves, size(Geo.x,1), size(Geo.x,2));
    Result.times = zeros(1,Set.time_incr/save);
    
    K = stiffK(Geo, Mat, Set);
    dof = Geo.dof;
    t = 0;
    for it = 1:Set.time_incr
        % K, Btot and Bvec are global
        u_v_kp1(dof) = Btot(dof,dof) \ (Btot(dof, dof)*u_v_k(dof) + f_0(dof)*dt/eta);
        u_e_kp1(dof) = K(dof,dof) \ (dt*fdot(dof) + K(dof,dof)*u_e_k(dof));
        u_kp1(dof) = u_v_kp1(dof) + u_e_kp1(dof);
        sigma_kp1 = (eye(size(D)) - dt*D/eta)*sigma_k+ D*Bvec*(u_kp1-u_k);

        u_k     = u_kp1;
        sigma_k = sigma_kp1;
        u_e_k   = u_e_kp1;
        u_v_k   = u_v_kp1;
        t = t + dt;

        if mod(it,save) == 0
            c = it/save;
            fprintf("it = %4i, |u| = %f, stress_x = %f \n", ...
                it, norm(u_k),  sigma_k(1));
            Result.sigmas(c,:) = sigma_k;
            Result.ut(c,:,:) = ref_nvec(u_k, Geo.n_nodes, Geo.dim);        
            Result.xt(c,:,:) = Geo.X + squeeze(Result.ut(c,:,:));
            Result.times(c) = t;
        end
    end
    Result.sigma_0  = sigma_0;
    Result.tau = eta/(Mat.P(1)/(1-Mat.P(2)^2));
    Result.strain_0 = Bvec*u_0;
    Result.u = ref_nvec(u_k, Geo.n_nodes, Geo.dim);
end   
