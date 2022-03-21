function stress = initStress(x, x_kp1, Geo, Mat, Set)
    % INITIAL STRAIN CASE
    if any(Geo.u, 'all')
        stress = calcStress(x, x_kp1, Geo, Mat, Set);
    % INITIAL STRESS CASE (FROM TRACTIONS)
    elseif any(Geo.tBC) && ~ischar(Geo.tBC)
        stress = zeros(Geo.n_nodes, Geo.vect_dim);
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
                stress(ne(a),:,:) = vec_mat(stress_ne, 1);
            end
        end
    elseif any(Geo.t, 'all') && ~ischar(Geo.t)
        stress = zeros(Geo.n_nodes, Geo.vect_dim);

        % TODO We should to do sigma*n = t. However, how do we define the
        % field t ? Is interpolation a good idea?
        return
    end
end