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

    if strcmpi(Mat.type, 'hookean')
        [~, Result.stress] = stressK(Result.x, Geo, Mat, Set); 
    end

    Result = saveOutData(1, c+1, k, u_t, stress_t, F, T, M, Geo, Mat, Set, Result);
    writeOut(1,Geo,Set,Result);
end
