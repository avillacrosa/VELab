function Result = visco(Geo, Mat, Set, Result)
	% TODO FIXME, why does this not go inside the loop?
    K  = constK(Geo.X, Geo, Mat, Set);
	BB = intBB(Geo, Set);
	M  = areaMassLI(Geo.X, Geo, Set);
	dof = vec_nvec(Geo.dof); fix = vec_nvec(Geo.fix); dt = Set.dt;

	% Vectorized form of variables

	u_t          = vec_nvec(Geo.u);
	strain_t     = zeros(Geo.n_nodes, Geo.vect_dim, Set.time_incr); 
	stress_t     = zeros(Geo.n_nodes, Geo.vect_dim, Set.time_incr);
	T			 = zeros(Geo.n_nodes*Geo.dim, Set.time_incr);
    F = vec_nvec(Geo.F); % THIS WAS WRONG MAN SHEEEESH

	strain_t(:,:,1)    = fullLinStr1(u_t(:,1), 1, Geo); 
	stress_t    = calcStress(strain_t, 0, stress_t, Geo, Mat, Set);
    t = 0;
	for k = 1:(Set.time_incr-1)
		% TODO FIXME Maybe move everything to backward euler?
		if strcmpi(Mat.rheo, 'kelvin')
            [u_t(:,k+1), T(:,k+1)] = eulerKV(u_t, dof, fix, dt, k, F, T, K, BB, Mat);
        elseif strcmpi(Mat.rheo, 'maxwell')
            [u_t(:,k+1), T(:,k+1)] = eulerMX(u_t, dof, fix, dt, k, F, T, K, BB, Mat);
        elseif strcmpi(Mat.rheo, 'fmaxwell')
            [u_t(:,k), T(:,k)] = eulerFMX(u_t, dof, fix, dt, k, F, T, K, BB, Mat);
		end
		% Calculate stress here
		if Set.calc_stress || Set.calc_strain
			strain_t(:,:,k) = fullLinStr1(u_t, k, Geo); 
			strain_t(:,:,k+1) = fullLinStr1(u_t, k+1, Geo);
			if Set.calc_stress
				stress_t = calcStress(strain_t, k, stress_t, Geo, Mat, Set);
			end
		end

        % Save values
        if mod(k, Set.save_freq) == 0 || k == 1
			if k == 1
				% TODO FIXME This is bad but convenient. Ideally we would
				% set all variables (stress is the hardest) to the 
				% initial time values before entering the loop, but that
				% takes effort.
				c = 0;
			else
				c = k/Set.save_freq;
			end
            Result = saveOutData(t, c+1, k, u_t, stress_t, strain_t, F, T, M, Geo, Mat, Set, Result);
            
            writeOut(c+1,Geo,Set,Result);
            fprintf("it = %4i, |u| = %f, |stress| = %e \n", k, norm(u_t(:,k)), max(abs(stress_t(:,1,k))));
        end
        t = t + Set.dt;
	end
    Result = saveOutData(t, c+1, k, u_t, stress_t, strain_t, F, T, M, Geo, Mat, Set, Result);
    writeOut(c+1,Geo,Set,Result);
end