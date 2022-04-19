function Result = visco(Geo, Mat, Set, Result)
	% TODO FIXME, why does this not go inside the loop?
    K  = constK(Geo.X, Geo, Mat, Set);
	BB = intBB(Geo, Set);
	M  = areaMassLI(Geo.X, Geo, Set);

	u_t          = zeros(Geo.n_nodes*Geo.dim, Set.time_incr);
	strain_t     = zeros(Geo.n_nodes, Geo.vect_dim, Set.time_incr); 
	stress_t     = zeros(Geo.n_nodes, Geo.vect_dim, Set.time_incr);
	T			 = zeros(Geo.n_nodes*Geo.dim, Set.time_incr);
    F = vec_nvec(Geo.F); % THIS WAS WRONG MAN SHEEEESH

    t = 0;
	% k = 1 corresponds to t = 0
	for k = 1:(Set.time_incr-1)
		if any(Geo.time==t)
			idx = find(Geo.time== t);
			u_presc = vec_nvec(Geo.u(:,:,idx));
			u_t(Geo.fix,k) = u_presc(Geo.fix);

		end

		if strcmpi(Mat.rheo, 'kelvin')
            [u_t, T] = eulerKV(u_t, k, F, T, K, BB, Geo, Set, Mat);
        elseif strcmpi(Mat.rheo, 'maxwell')
            [u_t, T] = eulerMX(u_t, k, F, T, K, BB, Geo, Set, Mat);
        elseif strcmpi(Mat.rheo, 'fmaxwell')
            [u_t, T] = eulerFMX(u_t, k, F, T, K, BB, Geo, Set, Mat);
		end
		% Calculate stress here
		if Set.calc_stress || Set.calc_strain
			strain_t(:,:,k)    = fullLinStr1(u_t(:,k), Geo); 
			strain_t(:,:,k+1)    = fullLinStr1(u_t(:,k+1), Geo);
			if Set.calc_stress
				stress_t(:,:,k) = calcStress(strain_t, k, stress_t, Geo, Mat, Set);
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