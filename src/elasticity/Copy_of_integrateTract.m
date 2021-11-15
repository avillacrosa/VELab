function F = integrateTract(x, t, Geo, Set)
    F = zeros(size(t));
    for ea = 1:size(Geo.na,1)
        nea = Geo.na(ea,2:end);
        xe  = x(nea,:);
        % "ITERATE" OVER THE "FIELD"
        for plane_idx = 1:size(Geo.fBC,1)
            axis    = Geo.fBC(plane_idx,1);
            coord   = Geo.fBC(plane_idx,2);
            t_axis  = Geo.fBC(plane_idx,3);
            t_value = Geo.fBC(plane_idx,4);
            for a = 1:Geo.n_nodes_elem_c
                if xe(:, axis) == coord
                    for gpa = 1:size(Set.gaussPointsC,1)
                        z = Set.gaussPointsC(gpa,:);
                        [N, ~] = fshape(Geo.n_nodes_elem_c, z);
                        [~, J] = getdNdx(xe(:,setxor(1:Geo.dim, axis)), z, Geo.n_nodes_elem_c);
                        n_id  = Geo.dim*(nea(a)-1)+t_axis;
                        F(n_id,:) = F(n_id,:) + ...
                                     t_value*N(a)*Set.gaussWeightsC(gpa)*J;
                    end
                end
            end
        end
    end
end