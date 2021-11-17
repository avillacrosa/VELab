function Result = visco(Geo, Mat, Set, Result)
    n_saves = fix(Set.time_incr/Set.save_freq);
    
    Result.x       = zeros(size(Geo.X,1), size(Geo.X,2), n_saves);
    Result.u       = zeros(size(Geo.X,1), size(Geo.X,2), n_saves);
    Result.stress  = zeros(Geo.n_nodes, Geo.vect_dim, n_saves);
    Result.F       = zeros(Geo.n_nodes, Geo.dim, n_saves);
    Result.t       = zeros(Geo.n_nodes, Geo.dim, n_saves);

    Result.times   = zeros(1, n_saves);
           
    K  = constK(Geo.X, Geo, Mat, Set);
    BB = intBB(Geo, Set);
    M  = areaMassNL(Geo.X, Geo, Set);
 
    u_k      = zeros(size(vec_nvec(Geo.X))); 
    F        = Geo.F;
    u_kp1    = zeros(size(vec_nvec(Geo.X)));
    stress_k = initStress(Geo.X + Geo.u, Geo, Mat, Set);
    
    t = 0; rc = 0;
    
    for it = 1:Set.time_incr
        if ismember(t, Geo.times)
            rc = rc + 1;
            % TODO/ THINK IS THIS GOOD???
            u_kt   = vec_nvec(Geo.u(:,:,rc));
            u_k(Geo.fix)   = u_kt(Geo.fix);
            if (rc+1) <= length(Geo.times)
                u_kp1t = vec_nvec(Geo.u(:,:,rc+1));
                u_kp1(Geo.fix) = u_kp1t(Geo.fix);
            end
        end
        
        if strcmpi(Mat.rheo, 'kelvin')
            [u_kp1, stress_kp1, F] = eulerKV(u_k, u_kp1, stress_k, F,...
                                                    K, BB, Geo, Set, Mat);
        elseif strcmpi(Mat.rheo, 'maxwell')
            [u_kp1, stress_kp1, F] = eulerMX(u_k, u_kp1, stress_k, F,...
                                                    K, BB, Geo, Set, Mat);
        end
        
        % Save values
        if mod(it, Set.save_freq) == 0
            c = it/Set.save_freq;
            Result.times(c)      = t;
            Result.u(:,:,c)      = ref_nvec(u_k, Geo.n_nodes, Geo.dim);        
            Result.x(:,:,c)      = Geo.X + Result.u(:,:,c);
            Result.stress(:,:,c) = stress_kp1; % TODO !
            Result.F(:,:,c)      = F;
            Result.t(:,:,c)      = M \ Result.F(:,:,c);
            fprintf("it = %4i, |u| = %f, stress_x = %f \n", ...
                    it, norm(u_k),  stress_k(1));  
        end
        
        % Update variables
        t = t + Set.dt;
        u_k(Geo.dof) = u_kp1(Geo.dof);
        stress_k     = stress_kp1;
    end
end