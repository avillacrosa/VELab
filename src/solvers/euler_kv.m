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
    
    K = stiffK(Geo, Mat, Set);
    Btot = linveB(Geo, Set);
    
    save = Set.save;
    dt   = Set.dt;
    eta  = Mat.visco;
    
    Result.strs  = zeros(Set.time_incr/save, Geo.vect_dim);
    Result.times = zeros(1,Set.time_incr/save);
    c = 0;
    t = 0;
    uk = zeros(size(Geo.x(:)));

    for it = 1:Set.time_incr
        if strcmpi(Set.euler_type, 'forward')
            stepMatrix = Btot-(dt/eta)*K;
            stepMatrix = setboundsK(stepMatrix, Geo);
            Btotbc = setboundsK(Btot, Geo);
            ukp1 = Btotbc\(stepMatrix*uk+Geo.f*(dt/eta));
        elseif strcmpi(Set.euler_type, 'backward')
            stepMatrix = K+eta*Btot/dt;
            stepMatrix = setboundsK(stepMatrix, Geo);
            Btotbc = setboundsK(Btot, Geo);
            ukp1 = stepMatrix\(Geo.f+Btotbc*uk*eta/dt);
        end
        
        t = t + dt;      
        
        if mod(it,save) == 0
            c = c + 1;
            urs = reshape(uk, [Geo.dim,Geo.n_nodes])';
            urskp1 = reshape(ukp1, [Geo.dim,Geo.n_nodes])';
            Fdk = deformF(Geo.x+urs,Geo.X,ones(1,Geo.dim),Geo.n_nodes_elem);
            Fdkp1 = deformF(Geo.x+urskp1,Geo.X,ones(1,Geo.dim),Geo.n_nodes_elem);
            strain_k   = (Fdk'+Fdk)/2-eye(size(Fdkp1));
            strain_kp1 = (Fdkp1'+Fdkp1)/2-eye(size(Fdkp1));
            stress = c*strain_k + eta*(strain_kp1 - strain_k)/Set.dt;
            Result.strs(c,:)  = vectorize(strain_k);
            Result.times(c) = t;
        end 
        uk = ukp1;
    end
    Result.sigma_0 = stress;
    Result.tau = eta/(Mat.P(1)/(1-Mat.P(2)^2))*ones(size(strain_k));
    Result.str_inf = stress/(Mat.P(1)*(1+Mat.P(2))/(1-Mat.P(2)^2));
%     Result.str_inf = D \ stress;
%     Result.str_inf = Result.str_inf(1);
    Result.K = K;
    Result.u = uk;
    Result.x = Geo.x + reshape(ukp1, [Geo.dim,Geo.n_nodes])';
end
