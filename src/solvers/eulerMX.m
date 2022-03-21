%--------------------------------------------------------------------------
% Solve a maxwell linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function u_kp1 = eulerMX(u_t, F, K, BB, Geo, Set, Mat)
    dt   = Set.dt;
    eta  = Mat.visco;

    u_k = u_t(:,1); u_kp1 = u_t(:,2);

    % Get integrals at equilibrium
    dof = Geo.dof;
    fix = Geo.fix;
    % K, Btot and Bvec are global
    % TODO FIXIT This is bad but since is 0 we get away with it
    fdot = zeros(size(Geo.F));
    u_e   = K(dof,dof)\fdot(dof); 
    
    u_kp1(dof) = BB(dof,dof)\(BB(dof,dof)*u_e/eta+...
                    -BB(dof,fix)*(u_kp1(fix)-u_k(fix))+...
                    F(dof)*dt/eta)+u_k(dof);
    F(fix)   = (BB(fix,fix)*(u_kp1(fix)-u_k(fix)) + ...
                  BB(fix,dof)*(u_kp1(dof)-u_k(dof)))*eta/dt;
    
end   
