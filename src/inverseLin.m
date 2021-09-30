%--------------------------------------------------------------------------
% Linear inverse problem...
%--------------------------------------------------------------------------
function Result = inverseLin(Geo, Mat, Set)
    K = stiffK(Geo,Mat,Set);
    t = K(Geo.fix, Geo.fix)*Geo.u(Geo.fix) + ...
        K(Geo.fix, Geo.dof)*Geo.u(Geo.dof);

    t2 = K(Geo.dof, Geo.dof)*Geo.u(Geo.dof) + ...
        K(Geo.dof, Geo.fix)*Geo.u(Geo.fix);
    
    Result.u = Geo.u;
    Result.t = t;
    Result.x = Geo.x + Geo.u;
end