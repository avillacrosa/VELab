function [Geo, Mat, Set, Result] = initializeData(Geo, Mat, Set)
	% This includes mesh, default input, boundary conditions...
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% As a rule of thumb, Geo and Result should include only vectorial
	% forms (Geo.n_nodes, Geo.dim) and we only turn to a 1D vector
	% (Geo.n_nodes*Geo.dim,1) when doing computations.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if Geo.ns(3) <= 1 
        fprintf("> Size of z <= 1, assuming a 2D problem \n");
	end
    [Geo.X, Geo.n, Geo.na] = meshgen(Geo.ns, Geo.ds);
    [Geo, Mat, Set]        = completeDefault(Geo, Mat, Set);
    [Geo, Mat, Set]        = completeData(Geo, Mat, Set);

	Geo.fix = zeros(Geo.n_nodes, Geo.dim);
	[Geo.u, Geo.fix] = buildDirichletIVP(Geo, Mat, Set);
	[Geo.u, Geo.fix] = buildDirichletBC(Geo, Mat, Set);
	Geo.dof = not(Geo.fix);
	
	Geo.X = Geo.X*Geo.x_units; 
	Geo.u = Geo.u*Geo.x_units;
	Geo.ds = Geo.ds*Geo.x_units;

    [Geo.t, Geo.F] = buildNeumann(Geo, Set);	
	if ~strcmpi(Set.output, 'none')
		Set    = initializeOutFolder(Set);
	end
    Result = initializeOutData(Geo, Mat, Set);
end