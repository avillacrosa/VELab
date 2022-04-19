function [Geo, Mat, Set, Result] = initializeData(Geo, Mat, Set)
	if size(Geo.ns,2) == 1	
        fprintf("> Assuming a TFM-type input \n");
        Geo     = buildTFM(Geo);
        Set.TFM = true;
	end

    [Geo.X, Geo.n, Geo.na] = meshgen(Geo.ns, Geo.ds);
    [Geo, Mat, Set]        = completeData(Geo, Mat, Set);
    [Geo, Mat, Set]        = buildHelp(Geo, Mat, Set);

    Set    = initializeOutFolder(Set);
    Result = initializeOutData(Geo, Mat, Set);
	
end