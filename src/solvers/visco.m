function Result = visco(Geo, Mat, Set, Result)
	stress  = load('stress.txt');
	G1 = 3.491862236912258e+04;
	texp = stress(:,1);
	stressexp = stress(:,2);
    K  = constK(Geo.X, Geo, Mat, Set);
    BB = intBB(Geo, Set);
    M  = areaMassLI(Geo.X, Geo, Set);
	if Mat.p > 0
		u_t             = zeros(Geo.n_nodes*Geo.dim, Mat.p);
		eps_t             = zeros(Geo.n_nodes, Geo.vect_dim, Mat.p);
	else
		u_t             = zeros(Geo.n_nodes*Geo.dim, Set.time_incr);
		eps_t             = zeros(Geo.n_nodes, Geo.vect_dim, Set.time_incr);
	end
	if Mat.q > 0
		stress_t        = zeros(Geo.n_nodes, Geo.vect_dim, Mat.q); 
	else
		stress_t        = zeros(Geo.n_nodes, Geo.vect_dim, Set.time_incr); 
	end

    F             = Geo.F;
	normsstress = zeros(Set.time_incr,1);
    writeOut(0,Geo,Set,Result);

    t = 0;
	for k = 1:(Set.time_incr-1)
        if size(Geo.u,3) == 1
            u_k_presc           = vec_nvec(Geo.u(:,:,1));
            u_t(Geo.fix,1)      = u_k_presc(Geo.fix);
            u_t(Geo.fix,2)      = u_k_presc(Geo.fix);
            u_t(Geo.fix,k)      = u_k_presc(Geo.fix);
        end
        
        if strcmpi(Mat.rheo, 'kelvin')
            u_t(:,Mat.p) = eulerKV(u_t, F, K, BB, Geo, Set, Mat);
			% This increases computational time by 3 in one of the best
			% case scenarios
			stress_t(:,:,Mat.q) = calcStressVE(u_t, k, stress_t, Geo, Mat, Set); 
			u_t(:,1)=u_t(:,2);
        elseif strcmpi(Mat.rheo, 'maxwell')
            u_t(:,Mat.p) = eulerMX(u_t, F, K, BB, Geo, Set, Mat);
			% This increases computational time by 3 in one of the best
			% case scenarios
			stress_t(:,:,Mat.q) = calcStressVE(u_t, k, stress_t, Geo, Mat, Set); 
			u_t(:,1)=u_t(:,2);
        elseif strcmpi(Mat.rheo, 'fmaxwell')
            u_t(:,k+1) = eulerFMX(u_t, k, F, K, BB, Geo, Set, Mat);
			% This increases computational time by 3 in one of the best
			% case scenarios
			eps_t(:,:,k+1) = fullLinStr1(u_t(:,k+1), Geo);
			stress_t(:,:,k+1) = calcStressVE(eps_t, k, stress_t, Geo, Mat, Set);
        end

        % Save values
        if mod(k, Set.save_freq) == 0
            c = k/Set.save_freq;
            % TODO FIXME !!!! Sending 2 F's, when one is a T
            Result = saveOutData(t, c, k, u_t, stress_t, F, M, Geo, Mat, Set, Result);
            
            writeOut(c,Geo,Set,Result);
            fprintf("it = %4i, |u| = %f, |stress| = %e \n", ...
                    k, norm(u_t(:,k+1)),  max(stress_t(:,1,k+1)));  
        end
        t = t + Set.dt;
		% TODO FIXME, this is bad since it assumes a forward euler is being
		% used, which is currently not the case for the fractional maxwell.
		% Either add a backward/forward if else statement here or handle
		% it inside the solvers.
%         stress_t(:,:,1)=stress_t(:,:,2);
		normsstress(k+1) = max(stress_t(:,1,k+1));
	end
% 	plot((1:size(normsstress))*Set.dt, normsstress)
	fem=loglog((1:size(normsstress))*Set.dt, normsstress)
	hold on
	exp=loglog(texp, stressexp*0.01*G1, 'ko');
	hold off
	legend([fem, exp], ["Numerical solution", "Experimental data"])
    Result = saveOutData(t, c+1, k, u_t, stress_t, F, M, Geo, Mat, Set, Result);
    writeOut(c+1,Geo,Set,Result);
end