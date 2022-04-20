%--------------------------------------------------------------------------
% Solve for the displacement given an input file data_f, using the
% appropiate solver for the problem (hookean = linear; neohookean/venant =
% nonlinear)
%--------------------------------------------------------------------------
function Result = runVE(data_f)
	%% Initialize base structures
    Geo = struct(); Mat = struct(); Set = struct();
	% Reformat input file data if user added .m extension
    t_start = tic();
    if endsWith(data_f, '.m')
        Set.input_file = data_f(1:end-2);
    else
        Set.input_file = data_f;
    end

	%% Add user based input
    [Geo, Mat, Set] = feval(Set.input_file, Geo, Mat, Set);
    
	%% Initialize other data necessary for sim
	% This includes mesh, default input, boundary conditions...
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% As a rule of thumb, Geo and Result should include only vectorial
	% forms (Geo.n_nodes, Geo.dim) and we only turn to a 1D vector
	% (Geo.n_nodes*Geo.dim,1) when doing computations.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[Geo, Mat, Set, Result] = initializeData(Geo, Mat, Set);

	%% Solve the system
    writeOut(1,Geo,Set,Result);
    Result = solveVE(Geo, Set, Mat, Result);

	%% Save the simulation info and exit
	plotResults(Geo, Mat, Set, Result);
    save(fullfile(Set.DirOutput,sprintf('result.mat')), 'Result');
    t_end = duration(seconds(toc(t_start)));
    t_end.Format = 'hh:mm:ss';
    fprintf("> Total real run time %s \n",t_end);
    fprintf("> Normal program finish :)\n\n");
end