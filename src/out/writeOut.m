function writeOut(c, Geo, Set, Result)
	if strcmpi(Set.output, 'none')
		return
	end
    if Geo.dim == 3
        x = Result.x(:,:,c);
        u = Result.u(:,:,c);
        F = Result.F(:,:,c);
        T = Result.T(:,:,c); 
        t = Result.t(:,:,c);
        stress = Result.stress(:,:,c);
    	fname = fullfile(Set.VTKDirOutput,sprintf("fem_t%02i.vtk", c-1));
    	writeVTK(Geo, x, u, F, T, t, stress, fname);
		for ti = 1:size(Result.u, 3)
        	fname = fullfile(Set.TFMDirDisp,sprintf("u_t%02i.txt", c-1));
        	writeVecTop(u, Geo, fname)
        	fname = fullfile(Set.TFMDirTrac,sprintf("t_t%02i.txt", c-1));
        	writeVecTop(t, Geo, fname)
		end
    end
end