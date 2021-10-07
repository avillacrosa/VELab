function Result = solve(Geo, Set, Mat, Result)
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
        end
    elseif strcmp(Set.p_type, "inverse")
        Result = inv_lin(Geo, Mat, Set, Result);
    end
end