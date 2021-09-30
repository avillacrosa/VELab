%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function Result = newton(Geo, Mat, Set, Result)

    ndim   = Geo.dim;
    nnodes = Geo.n_nodes;
    
    F = zeros(ndim*nnodes,1); 
    R = zeros(ndim*nnodes,1);
        
    % As a superficial load
    Geo.f = Geo.f / Set.newton_its;
    u = Geo.u';
    u = u(:);
    for i = 1:Set.newton_its
        % TODO this should be included if we want real superficial tensions
%         DF = integrateF(Geom, Set);
        DF = Geo.f;
        F  = F + DF; 
        R  = R - DF;
        it = 1;
        tol = norm(R)/norm(F);
        while(tol > Set.newton_tol || norm(u) > Set.newton_tol)
            K_c = stiffK(Geo, Mat, Set); 
            K_s = initStressK(Geo, Mat, Set); 
            K = K_c + K_s;

            if it == 1
                Geo.x = Geo.x + Geo.u;
            end
            corrR = K(Geo.dof, Geo.fix)*u(Geo.fix);
            u(Geo.dof) = K(Geo.dof, Geo.dof)\(-R(Geo.dof)-corrR);
            
            xv = Geo.x';
            xv = xv(:);
            xv(Geo.dof) = xv(Geo.dof) + u(Geo.dof);
            Geo.x = reshape(xv,[ndim,nnodes])';
            
            T = internalF(Geo, Mat, Set);
            R = T-F;
            tol = norm(R(Geo.dof))/norm(F);
            fprintf('INCR=%i ITER = %i tolR = %e tolX = %e\n',...
                     i,it,tol,norm(u(Geo.dof)));
            it = it + 1;
        end
        fprintf("> INCR %i CONVERGED IN %i ITERATIONS \n", i, it-1);
    end
    Result.x = Geo.x;
    Result.u = Geo.x - Geo.X;
end



