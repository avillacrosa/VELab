%--------------------------------------------------------------------------
% Solve a kelvin-voigt linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function [u_kp1, stress_kp1, F_k]  = eulerKV(u_k, u_kp1, stress_k, F_k, ...
                                                      K, BB, Geo, Set, Mat)
    eta = Mat.visco;
    dt  = Set.dt;
    
    dof = Geo.dof;
    fix = Geo.fix;
    
    if strcmpi(Set.euler_type, 'forward')
        leftcorr = BB(dof,dof)*u_k(dof)...
                     -BB(dof,fix)*(u_kp1(fix)-u_k(fix))...
                     -(K(dof,fix)*u_k(fix)+K(dof,dof)*u_k(dof))*dt/eta;
        u_kp1(dof) = BB(dof,dof)\(leftcorr+F_k(dof)*(dt/eta));
        F_k(fix) = K(fix,fix)*u_k(fix)+K(fix,dof)*u_k(dof)+...
                     BB(fix,fix)*(u_kp1(fix)-u_k(fix))*eta/dt+...
                     BB(fix,dof)*(u_kp1(dof)-u_k(dof))*eta/dt;
    elseif strcmpi(Set.euler_type, 'backward')
        % TODO: Actual TO DO
        stepMatrix = K+eta*Btot/dt;
        Btotbc = setboundsK(Btot, Geo);
        u_kp1 = stepMatrix\(Geo.F+Btotbc*u_k*eta/dt);
    end
    stress_kp1 = stress_k; %TODO !
end
