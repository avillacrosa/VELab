function [u, p_type] = buildUs(Geo)
    if ~isfield(Geo, 'u')
        fprintf("> u not specified. Assuming a forward problem \n")
        u = zeros(size(Geo.x));
        p_type = 'forward';
        for bci = 1:size(Geo.x0,1)
            n     = Geo.x0(bci,1);
            dim   = Geo.x0(bci,2);
            value = Geo.x0(bci,3);
            u(n,dim) = value;
        end
    elseif (isstring(Geo.u) || ischar(Geo.u)) && isempty(Geo.fBC)
        fprintf("> u given from file. Assuming an inverse problem \n")
        p_type = 'inverse';
        u = readU(Geo.u, Geo.dim);
    else
        fprintf("> u and t given. Assuming a forward problem with " + ...
                    "initial strain\n")
        if (isstring(Geo.u) || ischar(Geo.u))
            u = readU(Geo.u, Geo.dim);
        end
        p_type = 'forward';
    end
end