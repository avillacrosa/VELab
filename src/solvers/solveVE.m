function Result = solveVE(Geo, Set, Mat, Result)
    if isfield(Set, 'debug')
        fprintf('> Entering debug solver \n');
        Result = debug(Geo, Set, Mat, Result);
        return
    elseif Mat.visco ~= 0
        fprintf('> Solving linear viscoelasticity with %s rheology \n',...
                Mat.rheo);
        Result = visco(Geo, Mat, Set, Result);
    else
        fprintf("> Solving nonlinear elasticity \n");
        Result = elast(Geo, Mat, Set, Result);
    end
end