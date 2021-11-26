%--------------------------------------------------------------------------
% Generate a regular mesh with ns(1) nodes in x direction, ns(2) nodes in y
% direction and ns(3) nodes in z direction, separated by ds (array with one
% for each axis also)
%--------------------------------------------------------------------------
function [x, n, na] = meshgen(ns, ds)
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
        % TODO smart way to do this
        nelem = (ns(1)-1)*(ns(2)-1);
    else
        dim = 3;
        % TODO smart way to do this
        nelem = (ns(1)-1)*(ns(2)-1)*(ns(3)-1);
    end
    
    x  = zeros(nx*ny*nz, 3);
    n  = zeros(nelem, 2^dim);
    
    na = zeros(2*dim, 2^(dim-1)+1, nelem);
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
                    e_idx = n_idx + (1-nyi) + (nx+ny-1)*(1-nzi);
                    cs  = [bl, bl + 1, bl + nx + 1, bl + nx];
                    
                    csa = [ 2, bl, bl + 1
                            1, bl + 1, bl + nx + 1
                            2, bl + nx, bl + nx + 1
                            1, bl, bl + nx];
                    if dim == 3
                        cs = cat(2, cs, cs + nx*ny);
                        csa = [ 2, bl, bl+1, bl+nx*ny+1, bl+nx*ny
                                1, bl+1, bl+nx+1, bl+nx+1+nx*ny, bl+1+nx*ny
                                2, bl+nx, bl+nx+1, bl+nx+1+nx*ny, bl+nx+nx*ny
                                1, bl, bl+nx, bl+nx+nx*ny, bl+nx*ny
                                3, bl, bl+1, bl+nx+1, bl+nx
                                3, bl+nx*ny, bl+1+nx*ny, bl+nx+1+nx*ny, bl+nx+nx*ny];
                    end
                    
                    n(e_idx, :) = cs;
                    na(:, :, e_idx) = csa;
                end
            end
        end
    end    
    if dim == 2
        x = x(:,1:2);
    end
end