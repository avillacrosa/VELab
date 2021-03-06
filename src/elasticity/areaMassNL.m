function M = areaMassNL(x, Geo, Set)
    M = zeros(Geo.n_nodes);
    for ea = 1:size(Geo.na,1)
        nea = Geo.na(ea,2:end);
        xe  = x(nea,:);
        for gpa = 1:size(Set.gaussPointsC,1)
            z = Set.gaussPointsC(gpa,:);
            [N, ~] = fshape(Geo.n_nodes_elem_c, z);
            dxdz = getdxdz(xe, z, Geo.n_nodes_elem_c);
            x_zeta = dxdz(1,:);
            x_eta  = dxdz(2,:);
            n = cross(x_zeta, x_eta);
            Jn = norm(n);
            for a = 1:Geo.n_nodes_elem_c
                for b = 1:Geo.n_nodes_elem_c
                    neaa = nea(a);
                    neab = nea(b);
                    M(neaa, neab) = M(neaa, neab) + ...
                                       N(a)*N(b)*Set.gaussWeightsC(gpa)*Jn;
                end
            end
        end
    end
end