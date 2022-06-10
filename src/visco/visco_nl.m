function Result = visco_nl(Geo, Mat, Set, Result)
    M  = areaMassLISP(Geo.X, Geo, Set);
	dof = vec_nvec(Geo.dof); fix = vec_nvec(Geo.fix); 
	u_t = vec_nvec(Geo.u);
	u_t(:,1) = 0;
	stress_t = zeros(Geo.vect_dim, Geo.n_elem, Geo.n_nodes_elem, Set.time_incr);
	strain_t = zeros(Geo.n_nodes, Geo.vect_dim, Set.time_incr); 
	q_t		 = zeros(Geo.vect_dim, Geo.n_elem, Geo.n_nodes_elem, Set.time_incr);

    F = vec_nvec(Geo.F);
	F(:,1) = 0;
	t = 0;
	for k = 1:Set.time_incr-1
% 		df = F(:,k+1) / Set.n_steps;
%     	du = u_t(:,k+1) / Set.n_steps;
		for i = 1:Set.n_steps
			% TODO FIXME, temporal fix
%             F(:,k+1)   = F(:,k+1);
%             u_t(:,k+1) = u_t(:,k+1);
            T = internalF_v(k, vec_nvec(Geo.X) + u_t, q_t, Geo, Mat, Set);

        	R = T - F(:,k+1);

        	[u_t, stress_t(:,:,:,k+1), q_t] = newton_visco(k, u_t, q_t, dof, fix, i, R, F(:,k+1), Geo, Mat, Set);
		end
        if mod(k, Set.save_freq) == 0
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