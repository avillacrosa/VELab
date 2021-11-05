function u = buildDirichlet(Geo)
    if ~isfield(Geo, 'u')
        u = zeros(size(Geo.X));
        for bci = 1:size(Geo.x0,1)
            n     = Geo.x0(bci,1);
            dim   = Geo.x0(bci,2);
            value = Geo.x0(bci,3);
            u(n,dim) = value;
        end
    elseif (isstring(Geo.u) || ischar(Geo.u))
        fprintf("> Reading u from file \n")
        ustruct = load(Geo.u);
        u       = ustruct.u;
    else
        u = Geo.u;
    end
end