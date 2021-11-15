function Result = solveVE(Geo, Set, Mat, Result)
    if isfield(Set, 'debug')
        Result = debug(Geo, Set, Mat, Result);
        return
    end
    
    if Mat.visco ~= 0
        fprintf('> Solving linear viscoelasticity \n');
        Result = visco(Geo, Mat, Set, Result);
    else
        fprintf("> Solving nonlinear elasticity \n");
        Result = elast(Geo, Mat, Set, Result);
    end
%     if Mat.visco ~= 0 && strcmpi(Mat.rheo, 'kelvin')
%         fprintf(['> Solving linear viscoelasticity',...
%                 ' with Kelvin-Voigt rheology \n']);
%         Result = euler_kv(Geo, Mat, Set, Result);
%     elseif Mat.visco ~= 0 && strcmpi(Mat.rheo, 'invkelvin')
%         fprintf(['> Solving linear viscoelasticity',...
%                 ' with Kelvin-Voigt rheology \n']);
%         Result = inv_kv(Geo, Mat, Set, Result);
%     elseif Mat.visco ~= 0 && strcmpi(Mat.rheo, 'maxwell')
%         fprintf(['> Solving linear viscoelasticity',...
%                 ' with Maxwell rheology \n']);
%         Result = euler_mx(Geo, Mat, Set, Result);
%     elseif Mat.visco ~= 0 && strcmpi(Mat.rheo, 'invmaxwell')
%         fprintf(['> Solving linear viscoelasticity',...
%                 ' with Maxwell rheology \n']);
%         Result = inv_mx(Geo, Mat, Set, Result);
%     else
%         fprintf("> Solving nonlinear elasticity \n");
%         Result = elast(Geo, Mat, Set, Result);
%     end
end