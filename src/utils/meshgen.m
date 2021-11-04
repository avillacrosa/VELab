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
    
    % TODO Only for cubes/squares?
    na = zeros(2*dim*nelem-nelem, 2^(dim-1)+1);
    ccc = 1;
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
%                     csa = [ 1 bl, bl + 1
%                             2 bl + 1, bl + nx + 1
%                             1 bl + nx + 1, bl + nx
%                             2 bl + nx, bl];
                    csa = [ 1, bl, bl + 1
                            2, bl + 1, bl + nx + 1
                            1, bl + nx, bl + nx + 1
                            2, bl, bl + nx];
                    if dim == 3
                        % TODO smart 3d?
                        cs = cat(2, cs, cs + nx*ny);
                    end
                    n(e_idx, :) = cs;
%                     asl = nelem*(e_idx-1)+1;
%                     asl:asl+4
%                     for csaa = 1:4
%                         if ~ismember(csa(csaa,:), na, "rows")
%                             na(ccc, :) = csa(csaa,:);
%                             ccc = ccc + 1;
%                         end
%                     end
                end
            end
        end
    end    
    
    if dim == 2
        x = x(:,1:2);
    end
end