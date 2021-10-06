%--------------------------------------------------------------------------
% Linear inverse problem...
%--------------------------------------------------------------------------
function Result = inv_lin(Geo, Mat, Set, Result)
    K = stiffK(Geo,Mat,Set);
    
    t = K*vec_nvec(Geo.u);
    
    Result.tinv = t;
    Result.x = Geo.x + Geo.u;
    Result.X = Geo.X;
    Result.n = Geo.n;
    Result.u = Geo.u;
end