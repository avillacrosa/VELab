function Result = run(data_f)

    if endsWith(data_f, '.m')
        data_f = data_f(1:end-2);
    elseif size(data_f,1) == 0
        data_f = 'input_data';
    end
    
    [Geo, Mat, Set] = feval(data_f);
    [Geo, Mat, Set] = completeData(Geo, Mat, Set);

    Result = struct();
    Result.X = Geo.X; % For plotting purposes
    Result.n = Geo.n; % For plotting purposes
    
    if strcmpi(Set.type, 'linear')
        if Mat.visco ~= 0
            switch lower(Mat.rheo)
                case 'kelvin'
                    fprintf(['> Solving linear viscoelasticity',...
                            ' with Kelvin-Voigt rheology -- \n']);
                    Result = euler_kv(Geo, Mat, Set, Result);
                otherwise
                    fprintf(['> Solving linear viscoelasticity',...
                            ' with Maxwell rheology \n']);
                    Result = euler_mx(Geo, Mat, Set, Result);
            end
        else
            fprintf("> Solving linear elasticity \n");
            Result = lin_el(Geo, Mat, Set, Result);
        end
    else
        fprintf("> Solving nonlinear elasticity \n");
        Result = newton(Geo, Mat, Set, Result);
    end
    if Geo.dim == 2
        femplot(Result.X, Result.x, Result.n)
    elseif Geo.dim == 3
        writeVTK(Result.x, Geo, 'out.vtk');
        writeVTK(Geo.X, Geo, 'in.vtk');
    end
    fprintf("---- Normal program finish ----\n");
end