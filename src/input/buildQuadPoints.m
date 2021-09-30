function [gp, gw] = buildQuadPoints(Geo, Set)
    gp  = zeros(Set.n_quad^Geo.dim,Geo.dim);
    gw = zeros(Set.n_quad^Geo.dim, 1);
    for i = 1:Set.n_quad
        for j = 1:Set.n_quad
            if Geo.dim == 3
                for k = 1:Set.n_quad
                    z = [Set.quadx(i), Set.quadx(j), Set.quadx(k)];
                    w =  Set.quadw(i)*Set.quadw(j)*Set.quadw(k);
                    idx = k+Set.n_quad*(j-1)+Set.n_quad*Set.n_quad*(i-1);
                    gp(idx,:)  = z;
                    gw(idx) = w;
                end
            elseif Geo.dim == 2
                z = [Set.quadx(i), Set.quadx(j)];
                w =  Set.quadw(i)*Set.quadw(j);
                idx = j+2*(i-1);
                gp(idx,:) = z;
                gw(idx) = w;
            end
        end
    end
end