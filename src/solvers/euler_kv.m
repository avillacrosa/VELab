%--------------------------------------------------------------------------
% Solve a kelvin-voigt linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function Result = euler_kv(Geo, Mat, Set, Result)
    
    if strcmp(Set.euler_type, 'forward')
        fprintf("> Solving for Forward Euler's with dt = %f \n", Set.dt);
    elseif strcmp(Set.euler_type, 'backward')
        fprintf("> Solving for Backward Euler's with dt = %f \n", Set.dt);
    end
    
    [~, c] = material(Geo.x, Geo.X, ones(1,Geo.dim), Mat);
    D = constD(c);
    
    K = stiffK(Geo, Mat, Set);
    Btot = intB(Geo, Set);
    
    save = Set.save;
    dt   = Set.dt;
    eta  = Mat.visco;
    
    Result.strs  = zeros(Set.time_incr/save, Geo.vect_dim);
    Result.times = zeros(1,Set.time_incr/save);

    t = 0;

    uk   = vec_nvec(Geo.u);
    ukp1 = uk;
    
    dof = Geo.dof;
    for it = 1:Set.time_incr
        if strcmpi(Set.euler_type, 'forward')
            stepMatrix = Btot(dof,dof)-(dt/eta)*K(dof,dof);
            ukp1(dof) = Btot(dof,dof)\...
                        (stepMatrix*uk(dof)+Geo.f(dof)*(dt/eta));
        elseif strcmpi(Set.euler_type, 'backward')
            stepMatrix = K+eta*Btot/dt;
            Btotbc = setboundsK(Btot, Geo);
            ukp1 = stepMatrix\(Geo.f+Btotbc*uk*eta/dt);
        end
        
        t = t + dt;      
        
        if mod(it,save) == 0
            c = it/save;

            def_k   = Geo.x + ref_nvec(uk, Geo.n_nodes, Geo.dim);
            strain_k   = lin_strain(def_k(Geo.n(1,:),:), ...
                    Geo.X(Geo.n(1,:),:), ones(1,Geo.dim),Geo.n_nodes_elem);
                                    
            def_kp1 = Geo.x + ref_nvec(ukp1, Geo.n_nodes, Geo.dim);
            strain_kp1 = lin_strain(def_kp1(Geo.n(1,:),:), ...
                    Geo.X(Geo.n(1,:),:), ones(1,Geo.dim),Geo.n_nodes_elem);                        

            v_stress = D*vec_mat(strain_k) + eta*(vec_mat(strain_kp1) ...
                        - vec_mat(strain_k))/Set.dt;
                    
            Result.strs(c,:)  = vec_mat(strain_k);
            Result.times(c) = t;
        end 
        uk(dof) = ukp1(dof);
    end
    Result.sigma_0 = ref_mat(v_stress);
    
    Result.tau = eta/(Mat.P(1)/(1-Mat.P(2)^2))*ones(size(strain_k));
    Result.tau_num = viscTau(Result.times, Result.strs, (1-exp(-1)));
    
    Result.str_inf = ref_mat(v_stress)/(Mat.P(1)*(1+Mat.P(2))/(1-Mat.P(2)^2));

    Result.u = uk;
    Result.x = Geo.x + ref_nvec(ukp1, Geo.n_nodes, Geo.dim);
end
