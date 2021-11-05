function Result = inv_kv(Geo, Mat, Set, Result)
    ukp1 = vec_nvec(Geo.u(:,:,2));
    uk   = vec_nvec(Geo.u(:,:,1));
    % find ukp1 and uk
    Result.F = zeros(size(Geo.F));
    dt   = Set.dt;
    eta  = Mat.visco;

%     TTT = internalFv(Geo.X+Geo.u(:,:,1), Geo.X+Geo.u(:,:,2), Geo, Mat, Set);
    TTT2 = internalF(Geo.X, Geo, Mat, Set);
    % Because of linear elasticity...
    K = constK(Geo.X,Geo, Mat, Set);
    Btot = intBB(Geo, Set);
    
    fix = Geo.dof;

    stepM = Btot(fix,fix)-(dt/eta)*K(fix,fix);
    Result.F(fix) = (stepM*uk(fix) - Btot(fix, fix)*ukp1(fix))*eta/dt;

%     stepM = Btot-(dt/eta)*K;
%     Result.F = (stepM*uk - Btot*ukp1)*eta/dt;
end