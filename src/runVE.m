%--------------------------------------------------------------------------
% Solve for the displacement given an input file data_f, using the
% appropiate solver for the problem (hookean = linear; neohookean/venant =
% nonlinear)
%--------------------------------------------------------------------------
function Result = runVE(Geo, Mat, Set)
	%% Initialize other data necessary for sim
    t_start = tic;
	[Geo, Mat, Set, Result] = initializeData(Geo, Mat, Set);

	%% Solve the system
    writeOut(1,Geo,Set,Result);
    Result = solveVE(Geo, Set, Mat, Result);

	%% Save the simulation info and exit
    if ~strcmpi(Set.output, 'none')
	    plotResults(Geo, Mat, Set, Result);
        save(fullfile(Set.DirOutput,sprintf('result.mat')), 'Result');
    end
    t_end = duration(seconds(toc(t_start)));
    t_end.Format = 'hh:mm:ss';
    fprintf("> Total real run time %s \n",t_end);
    fprintf("> Normal program finish :)\n\n");
end