function M = areaMassNQ(x, Geo, Set)
    Set.gaussPointsC = Set.gaussPointsC*sqrt(3);
    M = zeros(Geo.n_nodes);
    for ea = 1:size(Geo.na,1)
        nea = Geo.na(ea,:);
        xe  = x(nea(2:end),setxor(1:Geo.dim, nea(1)));
        for gpa = 1:size(Set.gaussPointsC,1)
            z = Set.gaussPointsC(gpa,:);
            [~, J] = getdNdx(xe, z, Geo.n_nodes_elem_c);
            % TODO Repeats here?
            for a = 1:Geo.n_nodes_elem_c
                neaa = nea(a+1);
                M(neaa, neaa) = Set.gaussWeightsC(gpa)*J;
            end
        end
    end
end