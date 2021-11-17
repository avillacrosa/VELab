function M = areaMassLI(x, Geo, Set)
    M = zeros(Geo.n_nodes);
    for ea = 1:size(Geo.na,1)
        nea = Geo.na(ea,2:end);
        ax  = Geo.na(ea,1);
        xe  = x(nea,setxor(1:Geo.dim, ax));
        for gpa = 1:size(Set.gaussPointsC,1)
            z = Set.gaussPointsC(gpa,:);
            [N, ~] = fshape(Geo.n_nodes_elem_c, z);
            [~, J] = getdNdx(xe, z, Geo.n_nodes_elem_c);
            for a = 1:Geo.n_nodes_elem_c
                for b = 1:Geo.n_nodes_elem_c
                    neaa = nea(a);
                    neab = nea(b);
                    M(neaa, neab) = M(neaa, neab) + ...
                                        N(a)*N(b)*Set.gaussWeightsC(gpa)*J;
                end
            end
        end
    end
end