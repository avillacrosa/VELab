%--------------------------------------------------------------------------
% Solve for the displacement given an input file data_f, using the
% appropiate solver for the problem (hookean = linear; neohookean/venant =
% nonlinear)
%--------------------------------------------------------------------------
function Result = runVE(data_f)
    Geo = struct(); Mat = struct(); Set = struct();

    t_start = tic();
    if endsWith(data_f, '.m')
        Set.input_file = data_f(1:end-2);
    else
        Set.input_file = data_f;
    end

    [Geo, Mat, Set] = feval(Set.input_file, Geo, Mat, Set);
    
    if size(Geo.ns,2) == 1
        fprintf("> Assuming a TFM-type input \n");
        Geo     = buildTFM(Geo);
        Set.TFM = true;
    end
    
    [Geo.X, Geo.n, Geo.na] = meshgen(Geo.ns, Geo.ds);
    [Geo, Mat, Set]        = completeData(Geo, Mat, Set);
    [Geo, Mat, Set]        = buildHelp(Geo, Mat, Set);

    Set    = initializeOutFolder(Set);
    Result = initializeOutData(Geo, Set) ;

    Result = solveVE(Geo, Set, Mat, Result);

    Result = saveInfo(Geo, Mat, Set, Result);
    save(fullfile(Set.DirOutput,sprintf('result.mat')), 'Result');

    t_end = duration(seconds(toc(t_start)));
    t_end.Format = 'hh:mm:ss';
    fprintf("> Total real run time %s \n",t_end);
    fprintf("> Normal program finish :)\n\n");
end