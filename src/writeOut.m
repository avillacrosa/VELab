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
                    squeeze(Result.ut(i,:,:)), Geo, Result, Mat, ...
                    sprintf("out/out_t%02i_%s.vtk", i, name));
            end
        else
            
            writeVTK(Result.x, Result.u, Geo, Result, Mat, ...
                sprintf("out/out_%s.vtk", name));
        end
        writeVTK(Geo.X, zeros(size(Geo.x)), Geo, Result, Mat, ...
                    sprintf("out/in_%s.vtk", name));
    end
            
    usave = Result.u;
    save(sprintf('out/u_%s.mat', name), 'usave');
    
    u_str = "";
    for ui = 1:size(Result.u,1)
        u = Result.u(ui,:);
        if Geo.dim == 2
            u_str = u_str + sprintf("%.3f %.3f \n", u(1), u(2));
        elseif Geo.dim == 3
            u_str = u_str + sprintf("%.3f %.3f %.3f \n", u(1), u(2), u(3));
        end
        
    end
    fileH = fopen(sprintf('out/u_%s.txt', name), 'w+');
    fprintf(fileH, u_str);
end