function writeOut(Geo,Set,Mat,Result,name)
    if Geo.dim == 2
        femplot(Result.X, Result.x, Result.n)
    elseif Geo.dim == 3
        if isfield(Result, 'xt')
            if Mat.rheo ~= 0
                t = Set.n_saves;
            else
                t = Set.n_steps;
            end
            
            for i = 1:t
                writeVTK(squeeze(Result.xt(i,:,:)), ...
                    squeeze(Result.ut(i,:,:)), Geo, Result, Mat, Set, ...
                    sprintf("output/out_t%02i_%s.vtk", i, name));
            end
        else
            
            writeVTK(Result.x, Result.u, Geo, Result, Mat, Set, ...
                sprintf("output/out_%s.vtk", name));
        end
        writeVTK(Geo.X, zeros(size(Geo.x)), Geo, Result, Mat, Set, ...
                    sprintf("output/in_%s.vtk", name));
    end
    writeU(Geo, Set, Result, name);
end