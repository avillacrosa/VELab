function M = areaMassRS(x, Geo, Set)
    M = zeros(Geo.n_nodes);
    % TODO iterator as a variable?
    for ea = 1:size(Geo.na,1)
        nea = Geo.na(ea,:);
        % FIXIT this is only for elasticity...
        % As we're assuming that other components of vector x can be 
        % ignored...
        xe  = x(nea(2:end),setxor(1:Geo.dim, nea(1))); 
        for gpa = 1:size(Set.gaussPointsC,1)
            z = Set.gaussPointsC(gpa,:);
            [N, ~] = fshape(Geo.n_nodes_elem_c, z);
            [~, J] = getdNdx(xe, z, Geo.n_nodes_elem_c);
            for a = 1:Geo.n_nodes_elem_c
                neaa = nea(a+1);
                M(neaa, neaa) = M(neaa, neaa) + ... 
                                    N(a,:)*Set.gaussWeightsC(gpa)*J;
            end
        end
    end
end