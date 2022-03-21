function writeOut(c, Geo, Set, Result)
    if Geo.dim == 3
        x = Result.x(:,:,c+1);
        u = Result.u(:,:,c+1);
        F = Result.F(:,:,c+1);
        T = Result.F(:,:,c+1); % TODO FIXME!!!!!!!!!!!!!!!!!!!!
        t = Result.t(:,:,c+1);
        stress = Result.stress(:,:,c+1);

        fname = fullfile(Set.VTKDirOutput,sprintf("fem_t%02i.vtk", c));
        writeVTK(Geo, x, u, F, T, t, stress, fname);
        for ti = 1:size(Result.u, 3)
            fname = fullfile(Set.TFMDirDisp,sprintf("u_t%02i.txt", c));
            writeVecTop(u, Geo, fname)
            fname = fullfile(Set.TFMDirTrac,sprintf("t_t%02i.txt", c));
            writeVecTop(t, Geo, fname)
        end
    end
end