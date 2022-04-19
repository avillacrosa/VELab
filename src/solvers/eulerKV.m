%--------------------------------------------------------------------------
% Solve a kelvin-voigt linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function [u, T]  = eulerKV(u, k, F, T, K, BB, Geo, Set, Mat)
    eta = Mat.visco;
    dt  = Set.dt;
    
    dof = Geo.dof; fix = Geo.fix;

    leftcorr = BB(dof,dof)*u(dof,k)...
                 -BB(dof,fix)*(u(fix,k+1)-u(fix,k))...
                 -(K(dof,fix)*u(fix,k)+K(dof,dof)*u(dof,k))*dt/eta;
    u(dof,k+1) = BB(dof,dof)\(leftcorr+F(dof)*(dt/eta));

    T(fix,k+1) = K(fix,fix)*u(fix,k)+K(fix,dof)*u(dof,k)+...
                 BB(fix,fix)*(u(fix,k+1)-u(fix,k))*eta/dt+...
                 BB(fix,dof)*(u(dof,k+1)-u(dof,k))*eta/dt;
end
