%--------------------------------------------------------------------------
% Solve for the displacement given an input file data_f, using the
% appropiate solver for the problem (hookean = linear; neohookean/venant =
% nonlinear)
%--------------------------------------------------------------------------
function Result = run(data_f)
    t_start = tic();
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
    
    if size(Geo.ns,2) == 1
        fprintf("> Assuming a TFM-type input \n");
        Geo = buildTFM(Geo);
    end
    
    [Geo.x, Geo.n]  = meshgen(Geo.ns, Geo.ds);
    [Geo, Mat, Set] = completeData(Geo, Mat, Set);
    Result = solveVE(Geo, Set, Mat, Result);
    
    Result.X   = Geo.X; 
    Result.x   = Result.X + Result.u;
    Result.n   = Geo.n; 
    Result.dof = Geo.dof;
    Result.fix = Geo.fix;
    Result.t   = nodalToTract(Result.x, Geo, Set)*Result.T; 

    if isfield(Result,'T')
        Result.Tx  = Result.T(:,1);
        Result.Ty  = Result.T(:,2);
    end
    Result.P     = Mat.P;
    Result.visco = Mat.visco;
    
    writeOut(Geo,Set,Mat,Result,data_f);
    t_end = duration(seconds(toc(t_start)));
    t_end.Format = 'hh:mm:ss';
    fprintf("> Normal program finish :)\n");
    fprintf("> Total real run time %s \n",t_end);
end