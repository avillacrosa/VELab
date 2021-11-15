function [t, F] = buildNeumann(Geo, Set)
    % Translate load input format to load vector
%     massMa = areaMass(Geo.X, Geo, Set);
    if strcmpi(Geo.fBC, 'random')
        % TODO THIS WILL BE BROKEN...
        fprintf("> Generating random tractions on the top layer\n");
        t = randTFM(Geo, 15);
        F = integrateTract(t, Geo, Set);
    elseif Geo.traction
        t = fBCtoF(Geo);
        F = integrateTract(Geo.X, t, Geo, Set);
    else
        F = nodalBC(Geo, Geo.fBC, 1);
        t = massMa\F;
    end
end