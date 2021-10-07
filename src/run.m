%--------------------------------------------------------------------------
% Solve for the displacement given an input file data_f, using the
% appropiate solver for the problem (hookean = linear; neohookean/venant =
% nonlinear)
%--------------------------------------------------------------------------
function Result = run(data_f)

    if endsWith(data_f, '.m')
        data_f = data_f(1:end-2);
    elseif size(data_f,1) == 0
        data_f = 'input_data';
    end
    Geo = struct();
    Mat = struct();
    Set = struct();
    Result = struct();

    [Geo, Mat, Set] = feval(data_f, Geo, Mat, Set);
    [Geo, Mat, Set] = completeData(Geo, Mat, Set);

    Result = solve(Geo, Set, Mat, Result);
    
    Result.X   = Geo.X; % For plotting purposes
    Result.n   = Geo.n; % For plotting purposes
    Result.dof = Geo.dof;
    Result.fix = Geo.fix;
    Result.t  = ref_nvec(Geo.f, Geo.n_nodes, Geo.dim); % For plotting purposes
    Result.K0 = stiffK(Geo, Mat, Set);
    Result.T  = zeros(size(Geo.f));
    Result.F  = zeros(size(Geo.f));
    Result.R  = Result.K0*vec_nvec(Result.u);
    Result.T(Geo.fix) = Result.R(Geo.fix);
    Result.F(Geo.dof) = Result.R(Geo.dof);
    
    Result.R = ref_nvec(Result.R, Geo.n_nodes, Geo.dim);
    Result.T = ref_nvec(Result.T, Geo.n_nodes, Geo.dim);
    Result.F = ref_nvec(Result.F, Geo.n_nodes, Geo.dim);
    
    if Geo.dim == 2
        femplot(Result.X, Result.x, Result.n)
    elseif Geo.dim == 3
        writeVTK(Geo.X, Geo, Result, Mat, sprintf("out/in_%s.vtk", data_f));
        writeVTK(Result.x, Geo, Result, Mat, sprintf("out/out_%s.vtk", data_f));
    end
    fprintf("> Normal program finish\n");
end