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
    [~, c] = material(Geo.X(Geo.n(1,:),:), Geo.X(Geo.n(1,:),:), ones(1,Geo.dim), Mat);
    D = constD(c);
    
    % Get integrals at equilibrium
    Bvec = intB(Geo, Set);    % Integral of B.
    Btot = intBB(Geo, Set);   % Integral of B'*B. 
    
    u_k     = vec_nvec(Geo.u(:,:,end)); % If this is 0 but f is not -> Ct. stress, inf strain
    u_kp1   = zeros(size(u_k));
    u_e     = zeros(size(u_k));
    
    if any(u_k)
        sigma_k = D*Bvec*u_k;
    else
        sigma_k = zeros(Geo.vect_dim, 1);
    end

    f_0     = Geo.F; % If this is 0 but u is not -> Ct. strain, stress -> 0
    fdot = zeros(size(f_0));

    Result.x = zeros(size(Geo.X,1), size(Geo.X,2), Set.n_saves);
    Result.u = zeros(size(Geo.X,1), size(Geo.X,2), Set.n_saves);
    Result.sigmas  = zeros(Geo.vect_dim, Set.n_saves);
    Result.times = zeros(1,Set.time_incr/save);
    
    K = constK(Geo.X, Geo, Mat, Set);
    dof = Geo.dof;
    t = 0;
    for it = 1:Set.time_incr
        % K, Btot and Bvec are global
        % TODO FIXIT This is bad but since is 0 we get away with it
        u_e(dof)    = K(dof,dof)\fdot(dof); 
        u_kp1(dof) = Btot(dof,dof)\(Btot(dof,dof)*u_e(dof)/eta+f_0(dof)*dt/eta)...
                        +u_k(dof);
        sigma_kp1 = (eye(size(D)) - dt*D/eta)*sigma_k+ D*Bvec*(u_kp1-u_k);

        t = t + dt;

        if mod(it,save) == 0
            c = it/save;
            fprintf("it = %4i, |u| = %f, |stress_x| = %f \n", ...
                it, norm(u_k),  norm(ref_mat(sigma_k)));
            Result.sigmas(:,c) = sigma_k;
            Result.u(:,:,c) = ref_nvec(u_k, Geo.n_nodes, Geo.dim);        
            Result.x(:,:,c) = Geo.X + squeeze(Result.u(:,:,c));
            Result.times(c) = t;
        end
        u_k     = u_kp1;
        sigma_k = sigma_kp1;
    end
%     Result.sigma_0  = sigma_k;
    Result.tau = eta/(Mat.P(1)/(1-Mat.P(2)^2));
%     Result.strain_0 = Bvec*u_0;
end   
