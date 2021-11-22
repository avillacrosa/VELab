%--------------------------------------------------------------------------
% Solve for the displacement given an input file data_f, using the
% appropiate solver for the problem (hookean = linear; neohookean/venant =
% nonlinear)
%--------------------------------------------------------------------------
function Result = runVE(data_f)
    t_start = tic();
    
    if endsWith(data_f, '.m')
        data_f = data_f(1:end-2);
    elseif size(data_f,1) == 0
        data_f = 'input_data';
    end
    
    Geo = struct(); Mat = struct(); Set = struct(); Result = struct();

    [Geo, Mat, Set] = feval(data_f, Geo, Mat, Set);
    
    if size(Geo.ns,2) == 1
        fprintf("> Assuming a TFM-type input \n");
        [Geo.ns, Geo.uBC] = buildTFM(Geo);
        Set.TFM           = true;
    end
    
    [Geo.X, Geo.n, Geo.na]  = meshgen(Geo.ns, Geo.ds);
    [Geo, Mat, Set]         = completeData(Geo, Mat, Set);
    [Geo, Mat, Set]              = buildHelp(Geo, Mat, Set);
    
    Result = solveVE(Geo, Set, Mat, Result);
    Result = saveInfo(Geo, Mat, Set, Result);
    
    writeOut(Geo, Set, Mat, Result, data_f);

    t_end = duration(seconds(toc(t_start)));
    t_end.Format = 'hh:mm:ss';
    fprintf("> Total real run time %s \n",t_end);
    fprintf("> Normal program finish :)\n\n");
end