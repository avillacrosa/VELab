%--------------------------------------------------------------------------
% Solve for the displacement given an input file data_f, using the
% appropiate solver for the problem (hookean = linear; neohookean/venant =
% nonlinear)
%--------------------------------------------------------------------------
function Result = runVE(Geo, Mat, Set)
    %% Check if the input file is TFM or not
	if size(Geo.ns,2) == 1
        fprintf("> Assuming a TFM-type input \n");
        Geo     = buildTFM(Geo);
        Set.TFM = true;
	end
	%% Initialize other data necessary for sim
	% This includes mesh, default input, boundary conditions...
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% As a rule of thumb, Geo and Result should include only vectorial
	% forms (Geo.n_nodes, Geo.dim) and we only turn to a 1D vector
	% (Geo.n_nodes*Geo.dim,1) when doing computations.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[Geo, Mat, Set, Result] = initializeData(Geo, Mat, Set);
	if Set.TFM
		[Geo.u, Geo.dof, Geo.fix] = buildDirichletTFM(Geo, Set);
	else
		[Geo.u, Geo.dof, Geo.fix] = buildDirichlet(Geo, Set);
	end
    [Geo.t, Geo.F] = buildNeumann(Geo, Set);

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