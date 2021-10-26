function Result = solveVE(Geo, Set, Mat, Result)
    if isfield(Set, 'debug')
        Result = debug(Geo, Set, Mat, Result);
        return
    end
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
            Result = elast(Geo, Mat, Set, Result);
        end
    elseif strcmp(Set.p_type, "inverse")
%         Result = inv_lin(Geo, Mat, Set, Result);
        % TODO Unify this with elast as they do pretty much the same...
        Result = inv_elast(Geo, Mat, Set, Result);
    end
end