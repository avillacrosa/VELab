function Result = run(geo_file, mat_file, set_file)
    
    Result = struct();
    
    Geom = struct();
    Mat  = struct();
    Set  = struct();

    Geom = readGeom(Geom, geo_file);
    Mat  = readMat(Mat, mat_file);
    Set  = readSet(Set, set_file);
    
    [Mat, Geom, Set] = completeData(Mat, Geom, Set);
    if strcmpi(Set.type, 'linear')
        if Mat.visco ~= 0
            switch lower(Mat.rheo)
                case 'kelvin'
                    fprintf(['-- Solving linear viscoelasticity',...
                            ' with Kelvin-Voigt rheology -- \n']);
                    Result = euler_kv(Geom, Mat, Set, Result);
                otherwise
                    fprintf(['-- Solving linear viscoelasticity',...
                            ' with Maxwell rheology -- \n']);
                    Result = euler_mx(Geom, Mat, Set, Result);
            end
        else
            fprintf("-- Solving linear elasticity --\n");
            Result = lin_el(Geom, Mat, Set, Result);
        end
    else
        fprintf("-- Solving nonlinear elasticity --\n");
        Result = newton(Geom, Mat, Set, Result);
    end
 
end