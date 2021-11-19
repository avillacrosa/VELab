%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function Result = elast(Geo, Mat, Set, Result)
    F = zeros(Geo.dim*Geo.n_nodes,1); 
        
    % As a superficial load
    df = vec_nvec(Geo.F) / Set.n_steps;
    du = Geo.u / Set.n_steps;
    
    % TODO update this...
    Result.xn = zeros(Set.n_steps, Geo.n_nodes, Geo.dim);
    Result.un = zeros(Set.n_steps, Geo.n_nodes, Geo.dim);
    Result.x = Geo.X;

    for i = 1:Set.n_steps        
        Result.x = Result.x + du;
        F  = F + df; 
        R  = internalF(Result.x, Geo, Mat, Set) - F;
        Result = newton(Geo, Mat, Set, Result, i, R, F);
        Result.xn(i,:,:) = Result.x;
        Result.un(i,:,:) = Result.x - Geo.X;
    end

    Result.u = Result.x - Geo.X;
    
    T = internalF(Result.x, Geo, Mat, Set);
    if strcmpi(Mat.type, 'hookean')
        M = areaMassNL(Geo.X, Geo, Set);
    else
        M = areaMassNL(Geo.X, Geo, Set);
%         M = areaMassNL(Geo.X, Geo, Set);
    end
    
    % TODO Bad
    Result.F = zeros(size(T));
    Result.F(Geo.fix) = T(Geo.fix);
    Result.F = ref_nvec(Result.F, Geo.n_nodes, Geo.dim);
    Result.t = M \ Result.F;
end
