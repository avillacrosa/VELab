function [u, p_type] = buildUs(Geo, Mat)
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
    else
        if (isstring(Geo.u) || ischar(Geo.u))
            u = readU(Geo.u, Geo.dim);
        else
            u = Geo.u;
        end
        if isempty(Geo.fBC) && Mat.visco ~= 0
            fprintf("> u given from file. Assuming a forward "+...
                    "viscoelastic problem \n")
            p_type = 'forward';
        elseif isempty(Geo.fBC) 
            fprintf("> u given from file. Assuming an inverse problem \n")
            p_type = 'inverse';
        else
            fprintf("> u and t given. Assuming a forward problem with "+...
                    "initial strain\n")
            p_type = 'forward';
        end
    end
end