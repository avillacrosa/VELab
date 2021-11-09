function Result = inv_kv(Geo, Mat, Set, Result)
    ukp1 = vec_nvec(Geo.u(:,:,2));
    uk   = vec_nvec(Geo.u(:,:,1));
    % find ukp1 and uk
    Result.F = zeros(size(Geo.F));
    dt   = Set.dt;
    eta  = Mat.visco;
    
    % THERE IS NO INTERNAL FORCE IN THIS
    % Because of linear elasticity...
    K = constK(Geo.X, Geo, Mat, Set);
    Btot = intBB(Geo, Set);
    
    dof = Geo.dof;
    fix = Geo.fix; % Prescribed displacements here
    % This can be integrated to the forward KV
    leftcorr = Btot(dof,dof)*uk(dof)...
                -Btot(dof,fix)*(ukp1(fix)-uk(fix))...
                -(K(dof,fix)*uk(fix)+K(dof,dof)*uk(dof))*dt/eta;
    ukp1(dof) = Btot(dof,dof)\leftcorr;
    ukp1 = ref_nvec(ukp1, Geo.n_nodes, Geo.dim);
end