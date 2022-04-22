function [Geo, Mat, Set, Result] = initializeData(Geo, Mat, Set)
    [Geo.X, Geo.n, Geo.na] = meshgen(Geo.ns, Geo.ds);
    [Geo, Mat, Set]        = completeDefault(Geo, Mat, Set);
    [Geo, Mat, Set]        = completeData(Geo, Mat, Set);
	
	if Set.TFM
		[Geo.u, Geo.dof, Geo.fix] = buildDirichletTFM(Geo, Set);
	else
		[Geo.u, Geo.dof, Geo.fix] = buildDirichlet(Geo, Set);
	end
	Geo.X = Geo.X*Geo.x_units; 
	Geo.u = Geo.u*Geo.x_units;
	Geo.ds = Geo.ds*Geo.x_units;
    [Geo.t, Geo.F] = buildNeumann(Geo, Set);

    Set    = initializeOutFolder(Set);
    Result = initializeOutData(Geo, Mat, Set);
end