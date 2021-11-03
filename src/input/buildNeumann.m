function [t, F] = buildNeumann(Geo, Set)
    % Translate load input format to load vector
    if strcmpi(Geo.fBC, 'random')
        fprintf("> Generating random tractions on the top layer\n");
        F = randTFM(Geo, 5);
        t = tracMassM\F;
    elseif Geo.traction
        t = nodalBC(Geo, Geo.fBC, 1);
        Geo.t = t;
        tracMassM = nodalToTract(Geo.x, Geo, Set);
        F2 = integrateTract(t, Geo, Set);
        F = tracMassM*ref_nvec(t, Geo.n_nodes, Geo.dim);
    else
        F = nodalBC(Geo, Geo.fBC, 1);
        t = tracMassM\F;
    end
end