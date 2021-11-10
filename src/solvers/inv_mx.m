%--------------------------------------------------------------------------
% Solve a maxwell linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function Result = inv_mx(Geo, Mat, Set, Result)
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
    
    u_k     = vec_nvec(Geo.u(:,:,1)); % If this is 0 but f is not -> Ct. stress, inf strain
    u_kp1   = vec_nvec(Geo.u(:,:,2));
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
    fixf = Geo.fix;
    % K, Btot and Bvec are global
    % TODO FIXIT This is bad but since is 0 we get away with it
    u_e(dof)    = K(dof,dof)\fdot(dof); 
    u_kp1(dof) = Btot(dof,dof)\(Btot(dof,dof)*u_e(dof)/eta+...
                    -Btot(dof,fixf)*(u_kp1(fixf)-u_k(fixf))+...
                    f_0(dof)*dt/eta)+u_k(dof);
    sigma_kp1 = (eye(size(D)) - dt*D/eta)*sigma_k+ D*Bvec*(u_kp1-u_k);
    u_kp1 = ref_nvec(u_kp1, Geo.n_nodes, Geo.dim);
end   