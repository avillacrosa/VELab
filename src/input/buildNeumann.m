function [t, F] = buildNeumann(Geo, Set)
    % Translate load input format to load vector
%     massMa = areaMass(Geo.X, Geo, Set);
    if strcmpi(Geo.fBC, 'random')
        fprintf("> Generating random tractions on the top layer\n");
        t = randTFM(Geo, 15);
        F = integrateTract(t, Geo, Set);
    elseif Geo.traction
        t = nodalBC(Geo, Geo.fBC, 1);
        F = integrateTract(t, Geo, Set);
%         F = massMa*ref_nvec(t, Geo.n_nodes, Geo.dim);
%         F = vec_nvec(F);
    else
        F = nodalBC(Geo, Geo.fBC, 1);
        t = massMa\F;
    end
end