%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function Result = elast_t(Geo, Mat, Set, Result)
    t = 0;
	for k = 1:(Set.time_incr-1)

		if any(Geo.time==t)
			idx = find(Geo.time== t);
			u_presc = vec_nvec(Geo.u(:,:,idx));
			u_t(Geo.fix,k) = u_presc(Geo.fix);
		end
		
    	% As a superficial load. This should be the time F
    	df = vec_nvec(Geo.F) / Set.n_steps;
    	du = Geo.u / Set.n_steps;
	
    	for i = 1:Set.n_steps        
        	Result.x = Result.x + du;
        	F  = F + df; 
        	R  = internalF(Result.x, Geo, Mat, Set) - F;
        	Result = newton(Geo, Mat, Set, Result, i, R, F);
        	Result.xn(i,:,:) = Result.x;
        	Result.un(i,:,:) = Result.x - Geo.X;
    	end
	
		if Set.calc_stress
			eps_t(:,:,k)    = fullLinStr1(u_t(:,k), Geo);
			stress_t(:,:,k) = calcStress(eps_t, k, stress_t, Geo, Mat, Set);
		end

		if mod(k, Set.save_freq) == 0
            c = k/Set.save_freq;
            Result = saveOutData(t, c, k, u_t, stress_t, F, T, M, Geo, Mat, Set, Result);
            
            writeOut(c,Geo,Set,Result);
            fprintf("it = %4i, |u| = %f, |stress| = %e \n", k, norm(u_t(:,k)), max(stress_t(:,1,k)));
        end
        t = t + Set.dt;
	end

	Result = saveOutData(t, c+1, k, u_t, stress_t, F, T, M, Geo, Mat, Set, Result);
    writeOut(c+1,Geo,Set,Result);
end