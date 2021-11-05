%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function Result = elast(Geo, Mat, Set, Result)
    F = zeros(Geo.dim*Geo.n_nodes,1); 
        
    % As a superficial load
    df = Geo.F / Set.n_steps;
    du = Geo.u / Set.n_steps;
    
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

    % Generalization of u result. Second axis is time (1 for elasticity)
    Result.u = zeros(size(Result.x,1), size(Result.x,2), 1);
    Result.u(:,:,1) = Result.x - Geo.X;
    
    % TODO Bad
    xs = Result.x;
    Result.x = zeros(size(Result.x,1), size(Result.x,2), 1);
    Result.x(:,:,1) = xs;
end
