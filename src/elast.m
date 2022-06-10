%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function Result = elast(Geo, Mat, Set, Result)
    M  = areaMassLISP(Geo.X, Geo, Set);
    dof = vec_nvec(Geo.dof); fix = vec_nvec(Geo.fix); 

	u_t          = vec_nvec(Geo.u);
	strain_t     = nan(Geo.n_nodes, Geo.vect_dim, Set.time_incr); 
	stress_t     = nan(Geo.n_nodes, Geo.vect_dim, Set.time_incr);
	T			 = zeros(Geo.n_nodes*Geo.dim, Set.time_incr);
    F            = vec_nvec(Geo.F);

    t = 0;
    for k = 1:Set.time_incr
    	df = F(:,k) / Set.n_steps; Fi = zeros(size(F(:,k)));
    	du = u_t(:,k) / Set.n_steps; ui = zeros(size(u_t(:,k)));
    	for i = 1:Set.n_steps
            Fi = Fi + df;
            ui = ui + du;
            T = internalF(vec_nvec(Geo.X) + ui, Geo, Mat, Set);
        	R  = T - Fi;
			% TODO FIXME, define dof and fix inside of newton function
        	[u_t(:,k), stress_gp] = newton(ui, dof, fix, i, R, Fi, Geo, Mat, Set);
    	end
	
		if Set.calc_stress || Set.calc_strain
            for e = 1:Geo.n_elem
                stress_gp_e   = vec_mat(stress_gp(:,:,:,e),1);
                stress_gp_nod = recoverNodals(stress_gp_e', Geo, Set);
                stress_t(Geo.n(e,:),:,k) = stress_gp_nod;
            end
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