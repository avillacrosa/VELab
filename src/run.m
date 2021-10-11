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

    Result = solveVE(Geo, Set, Mat, Result);
    
    Result.X   = Geo.X; % For plotting purposes
    Result.x   = Result.X + Result.u;
    Result.n   = Geo.n; % For plotting purposes
    Result.dof = Geo.dof;
    Result.fix = Geo.fix;
    Result.t  = ref_nvec(Geo.f, Geo.n_nodes, Geo.dim); % For plotting purposes
    Result.K0 = stiffK(Geo, Mat, Set);
    
    if Geo.dim == 2
        femplot(Result.X, Result.x, Result.n)
    elseif Geo.dim == 3
        writeVTK(Geo.X, Geo, Result, Mat, sprintf("out/in_%s.vtk", data_f));
        writeVTK(Result.x, Geo, Result, Mat, sprintf("out/out_%s.vtk", data_f));
    end
    
    usave = Result.u;
    save(sprintf('out/u_%s.mat', data_f), 'usave');
    fprintf("> Normal program finish\n");
end