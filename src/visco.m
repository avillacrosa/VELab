function Result = visco(Geo, Mat, Set, Result)
    X  = vec_nvec(Geo.X);
    K  = constK(X, Geo, Mat, Set);
	BB = constK(X, Geo, Mat, Set, true);
% 	M  = areaMassLI(Geo.X, Geo, Set); % TODO FIXME TIME AND MEMORY SINK HERE
	M  = areaMassLISP(Geo.X, Geo, Set); % TODO FIXME TIME AND MEMORY SINK HERE

	dof = vec_nvec(Geo.dof); fix = vec_nvec(Geo.fix); dt = Set.dt;

	% Vectorized form of variables
	u_t          = vec_nvec(Geo.u);
	u_v_t        = vec_nvec(Geo.u);

	strain_t     = nan(Geo.n_nodes, Geo.vect_dim, Set.time_incr); 
	stress_t     = nan(Geo.n_nodes, Geo.vect_dim, Set.time_incr);
	T			 = zeros(Geo.n_nodes*Geo.dim, Set.time_incr);
    F			 = vec_nvec(Geo.F);


	if Set.calc_stress || Set.calc_strain
		strain_t(:,:,1)    = fullLinStr1(u_t(:,1), 1, Geo); 
		if Set.calc_stress
			stress_t    = calcStress(strain_t, 0, stress_t, Geo, Mat, Set);
		end
	end
    t = 0;
    for k = 2:Set.time_incr
		if strcmpi(Mat.rheo, 'kelvin')
            [u_t, T] = eulerKV(u_t, dof, fix, dt, k-1, F, T, K, BB, Mat);
        elseif strcmpi(Mat.rheo, 'maxwell')
%             [u_t, T] = eulerMX(u_t, dof, fix, dt, k-1, F, T, K, BB, Mat);
            [u_t, u_v_t, T] = eulerMX_INT(u_t, u_v_t, dof, fix, dt, k-1, F, T, K, BB, Geo, Mat, Set);
        elseif strcmpi(Mat.rheo, 'fmaxwell')
            [u_t, T] = eulerFMX(u_t, dof, fix, dt, k-1, F, T, K, BB, Mat, Set);
		end
		% Calculate stress here
		if Set.calc_stress || Set.calc_strain
			strain_t(:,:,k) = fullLinStr1(u_t, k, Geo); 
			if Set.calc_stress
				stress_t = calcStress(strain_t, k, stress_t, Geo, Mat, Set);
			end
		end

        % Save values
        if mod(k, Set.save_freq) == 0 || k == 1
			c = k/Set.save_freq;
            Result = saveOutData(t, c+1, k, u_t, stress_t, strain_t, F, T, M, Geo, Mat, Set, Result);
            writeOut(c+1,Geo,Set,Result);
		
            fprintf("it = %4i, t = %.2f, |u| = ( ", k, t);
            fprintf("%.2f ", vecnorm(Result.u(:,:,c+1), 2, 1));
            fprintf("), |stress| = ( ")
            fprintf("%.2f ", vecnorm(Result.stress(:,:,c+1), 2, 1));
    		fprintf(") \n")
        end
        t = t + Set.dt;
    end
end