%--------------------------------------------------------------------------
% Linear inverse problem...
%--------------------------------------------------------------------------
function Result = inv_lin(Geo, Mat, Set)
    K = stiffK(Geo,Mat,Set);
    Result.u = Geo.u;
    u = Geo.u';
    u = u(:);
    t = K*u;
    Result.t = t;
    Result.x = Geo.x + Geo.u;
end