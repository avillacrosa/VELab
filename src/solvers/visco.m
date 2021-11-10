function Result = visco(Geo, Mat, Set, Result)
    Result.x       = zeros(size(Geo.X,1), size(Geo.X,2), Set.n_saves);
    Result.u       = zeros(size(Geo.X,1), size(Geo.X,2), Set.n_saves);
    Result.stress  = zeros(Geo.vect_dim, Set.n_saves);
    Result.times   = zeros(1, Set.n_saves);
           
    K = constK(Geo.X, Geo, Mat, Set);
    BB = intBB(Geo, Set);
    
    u_k      = zeros(size(vec_nvec(Geo.X))); 
    u_kp1    = zeros(size(vec_nvec(Geo.X)));
    stress_k = zeros(Geo.vect_dim,1);

    save     = fix(Set.time_incr/Set.n_saves);
    
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
            [u_kp1, stress_kp1] = euler_kv(u_k, u_kp1, stress_k, K, BB, ...
                                            Geo, Set, Mat);
        elseif strcmpi(Mat.rheo, 'maxwell')
            [u_kp1, stress_kp1] = euler_mx(u_k, u_kp1, stress_k, K, BB, ...
                                            Geo, Set, Mat);
        end
        
        if mod(it,save) == 0
            c = it/save;
            Result.times(c)      = t;
            Result.u(:,:,c)      = ref_nvec(u_k, Geo.n_nodes, Geo.dim);        
            Result.x(:,:,c)      = Geo.X + Result.u(:,:,c);
            Result.stress(:,c)   = stress_kp1; % TODO !
            fprintf("it = %4i, |u| = %f, stress_x = %f \n", ...
                    it, norm(u_k),  stress_k(1));  
        end
        
        t = t + Set.dt;
        u_k(Geo.dof) = u_kp1(Geo.dof);
        stress_k     = stress_kp1;
    end
end