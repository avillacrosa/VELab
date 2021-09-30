%--------------------------------------------------------------------------
% Solve for the displacement given an input file data_f, using the
% appropiate solver for the problem (hookean = linear; neohookean/venant =
% nonlinear)
%--------------------------------------------------------------------------
function Result = run(data_f)

    if endsWith(data_f, '.m')
        data_f = data_f(1:end-2);
    elseif size(data_f,1) == 0
        data_f = 'input_data';
    end
    Geo = struct();
    Mat = struct();
    Set = struct();
    Result = struct();

    [Geo, Mat, Set] = feval(data_f, Geo, Mat, Set);
    [Geo, Mat, Set] = completeData(Geo, Mat, Set);

    Result.X = Geo.X; % For plotting purposes
    Result.n = Geo.n; % For plotting purposes

    if strcmp(Set.p_type,"forward")
    if Mat.visco ~= 0
        switch lower(Mat.rheo)
            case 'kelvin'
                fprintf(['> Solving linear viscoelasticity',...
                        ' with Kelvin-Voigt rheology \n']);
                Result = euler_kv(Geo, Mat, Set, Result);
            otherwise
                fprintf(['> Solving linear viscoelasticity',...
                        ' with Maxwell rheology \n']);
                Result = euler_mx(Geo, Mat, Set, Result);
        end
    else
        fprintf("> Solving nonlinear elasticity \n");
        Result = newton(Geo, Mat, Set, Result);
%         Result = lin_el(Geo, Mat, Set, Result);
    end
    elseif strcmp(Set.p_type, "inverse")
        Result = inverseSolution(Geo,Mat,Set);
    end
    
    Result.t = reshape(Geo.f, [Geo.dim, Geo.n_nodes])'; % For plotting purposes

    if Geo.dim == 2
        femplot(Result.X, Result.x, Result.n)
    elseif Geo.dim == 3
        writeVTK(Geo.X, Geo, Result, Mat, 'in.vtk');
        writeVTK(Result.x, Geo, Result, Mat, 'out.vtk');
    end
    fprintf("> Normal program finish\n");
end