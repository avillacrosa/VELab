%--------------------------------------------------------------------------
% Solve a maxwell linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function [u, T] = eulerMX(u, k, F, T, K, BB, Geo, Set, Mat)
    dt   = Set.dt;
    eta  = Mat.visco;

    % Get integrals at equilibrium
    dof = Geo.dof; fix = Geo.fix;
    % K, Btot and Bvec are global
    % TODO FIXIT This is bad but since is 0 we get away with it
    fdot = zeros(size(Geo.F));
    u_e   = K(dof,dof)\fdot(dof); 
    
    u(dof,k+1) = BB(dof,dof)\(BB(dof,dof)*u_e/eta+...
                    -BB(dof,fix)*(u(fix,k+1)-u(fix,k))+...
                    F(dof)*dt/eta)+u(dof,k);
    T(fix,k+1)   = (BB(fix,fix)*(u(fix,k+1)-u(fix,k)) + ...
                  BB(fix,dof)*(u(dof,k+1)-u(dof,k)))*eta/dt;
    
end   
