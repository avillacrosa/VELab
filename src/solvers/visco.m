function Result = visco(Geo, Mat, Set, Result)

    K  = constK(Geo.X, Geo, Mat, Set);
    BB = intBB(Geo, Set);
    M  = areaMassLI(Geo.X, Geo, Set);

    u_t             = zeros(Geo.n_nodes*Geo.dim, Mat.p);
    stress_t        = zeros(Geo.n_nodes, Geo.vect_dim, Mat.q); 

    F             = Geo.F;

    writeOut(0,Geo,Set,Result);

    t = 0;
    for k = 1:(Set.time_incr-1)
        if size(Geo.u,3) == 1
            u_k_presc         = vec_nvec(Geo.u(:,:,1));
            u_t(Geo.fix,1)      = u_k_presc(Geo.fix);
            u_t(Geo.fix,2)      = u_k_presc(Geo.fix);
        end
        
        if strcmpi(Mat.rheo, 'kelvin')
            u_t(:,Mat.p) = eulerKV(u_t, F, K, BB, Geo, Set, Mat);
        elseif strcmpi(Mat.rheo, 'maxwell')
            u_t(:,Mat.p) = eulerMX(u_t, F, K, BB, Geo, Set, Mat);
        elseif strcmpi(Mat.rheo, 'fmaxwell')
            u_t(:,1) = eulerFMX(u_t, F, K, BB, Geo, Set, Mat);
        end
%         linStr2 = fullLinStr2(u_t(:,Mat.p), Geo);
        stress_t(:,:,Mat.q) = calcStressVE(u_t, stress_t, Geo, Mat, Set); % This increases computational time by 3...

        % Save values
        if mod(k, Set.save_freq) == 0
            c = k/Set.save_freq;
            % TODO FIXME !!!! Sending 2 F's, when one is a T
            Result = saveOutData(t, c, u_t, stress_t, F, M, Geo, Mat, Set, Result);
            
            writeOut(c,Geo,Set,Result);
            fprintf("it = %4i, |u| = %f, |stress| = %e \n", ...
                    k, norm(u_t(:,1)),  norm(Result.stress(:,:,c+1)));  
        end
        t = t + Set.dt;
        u_t(:,1)=u_t(:,2);
%         k
%         stress_t(:,:,1)=stress_t(:,:,2);
    end
    Result = saveOutData(t, c+1, u_t, stress_t, F, M, Geo, Mat, Set, Result);
    writeOut(c+1,Geo,Set,Result);
end