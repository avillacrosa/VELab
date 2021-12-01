function writeOut(Geo,Set,Mat,Result,name)
    if Geo.dim == 2
        femplot(Result.X, Result.x(:,:,end), Result.n)
    elseif Geo.dim == 3
        if Mat.rheo ~= 0
            t = fix(Set.time_incr/Set.save_freq);
        else
            t = Set.n_steps;
        end
        for i = 1:t
            fname = sprintf("output/out_t%02i_%s.vtk", i, name);
            x = Result.x(:,:,i);
            u = Result.u(:,:,i);
            writeVTK(x, u, Geo, Result, Mat, Set, fname);
        end
        writeVTK(Geo.X, zeros(size(Geo.X)), Geo, Result, Mat, ...
                    Set, sprintf("output/in_%s.vtk", name));
    end
    for ti = 1:size(Result.u, 3)
        writeVecTop(Result.u(:,:,ti), Geo, ...
                    sprintf("output/u_tfm_t%02i_%s.txt", ti, name))
        writeVecTop(Result.t(:,:,ti), Geo, ...
                    sprintf("output/t_tfm_t%02i_%s.txt", ti, name))
    end
    save(sprintf('output/result_%s.mat', name), 'Result');
end