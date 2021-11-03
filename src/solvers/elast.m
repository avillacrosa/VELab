%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function Result = elast(Geo, Mat, Set, Result)
    
    F = zeros(Geo.dim*Geo.n_nodes,1); 
    R = zeros(Geo.dim*Geo.n_nodes,1);
        
    % As a superficial load
    df = Geo.F / Set.n_steps;
    du = Geo.u / Set.n_steps;
    
    Result.xn = zeros(Set.n_steps, Geo.n_nodes, Geo.dim);
    Result.un = zeros(Set.n_steps, Geo.n_nodes, Geo.dim);
    
    for i = 1:Set.n_steps        
        Result.x = Geo.X + du;
%         F  = F + df; 
%         R  = R - df;
        Result = newton(Geo, Mat, Set, Result, i, R, F);
        Result.xn(i,:,:) = Result.x;
        Result.un(i,:,:) = Result.x - Geo.X;
    end
    
    Result.u = Result.x - Geo.X;
end



