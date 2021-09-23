function [x, n] = meshgen(ns, ds)
    nx = ns(1);
    ny = ns(2);
    nz = ns(3);
    
    dx = ds(1);
    dy = ds(2);
    dz = ds(3);
    
    if nz <= 1 
        fprintf("> Size of z <= 1, assuming a 2D problem \n");
        dim = 2;
        nz = 1;
        dz = 1;
    else
        dim = 3;
    end
    
    nelem = (ns(1)-1)*(ns(2)-1);     
    x = zeros(nx*ny*nz, 3);
    n = zeros(nelem, 2^dim);
    
    for nzi = 1:nz
        for nyi = 1:ny
            for nxi = 1:nx
                xc = (nxi-1)*dx;
                yc = (nyi-1)*dy;
                zc = (nzi-1)*dz;
                n_idx = (nzi-1)*(ny*nx) + nx*(nyi-1) + nxi;
                x(n_idx, :) = [xc, yc, zc];
                bl = n_idx;
                if dim == 2
                    cond = nxi ~= nx && nyi ~= ny;
                elseif dim == 3
                    cond = nxi ~= nx && nyi ~= ny && nzi ~= nz;
                end
                if cond
                    e_idx = n_idx - nyi + 1 - nzi + 1;
                    cs = [bl, bl + 1, bl + nx + 1, bl + nx];
                    if dim == 3
                        cs = cat(2, cs, cs + nx*ny);
                    end
                    n(e_idx, :) = cs;
                end
            end
        end
    end    
    
    if dim == 2
        x = x(:,1:2);
    end
end