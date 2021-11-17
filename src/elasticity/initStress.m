function stress = initStress(x, Geo, Mat, Set)
    stress = zeros(Geo.n_nodes, Geo.vect_dim);
    % INITIAL STRAIN CASE
    if any(Geo.u)
        for e = 1:Geo.n_elem
            ne = Geo.n(e,:);
            xe = x(ne,:);
            Xe = Geo.X(ne,:);
            stress_ne = zeros(Geo.n_nodes_elem, Geo.dim, Geo.dim);
            for a = 1:Geo.n_nodes_elem
                for gp = 1:size(Set.gaussPoints,1)
                    z = Set.gaussPoints(gp,:);
                    [sigma, ~] = material(xe, Xe, z, Mat);
                    stress_ne(gp,:, :) = sigma;
                end
            end
            [~, stress_ne] = recoverNodals(stress_ne, Geo, Set);
            stress(ne,:) = stress_ne;
        end
    % INITIAL STRESS CASE (FROM TRACTIONS)
    elseif any(Geo.tBC) && ~ischar(Geo.tBC)
        for e = 1:Geo.n_elem
            ne = Geo.n(e,:);
            Xe = Geo.X(ne,:);
            for a = 1:Geo.n_nodes_elem
                stress_ne = zeros(Geo.dim, Geo.dim);
                for plane_idx = 1:size(Geo.tBC)
                    axis    = Geo.tBC(plane_idx,1);
                    coord   = Geo.tBC(plane_idx,2);
                    t_axis  = Geo.tBC(plane_idx,3);
                    t_value = Geo.tBC(plane_idx,4);
                    if Xe(a, axis) == coord
                        stress_ne(axis, t_axis) = t_value;
                    end
                end
                stress(ne(a),:,:) = vec_mat(stress_ne);
            end
        end
    end
end