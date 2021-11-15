%--------------------------------------------------------------------------
% Compute nodal displacement Neumann conditions given user input format
%--------------------------------------------------------------------------
function t = buildTractField(Geo)
    t  = zeros(Geo.n_nodes,Geo.dim,Geo.dim);
    for plane_idx = 1:size(Geo.fBC, 1)
        axis    = Geo.fBC(plane_idx,1);
        coord   = Geo.fBC(plane_idx,2);
        t_axis  = Geo.fBC(plane_idx,3);
        t_value = Geo.fBC(plane_idx,4);
        for e = 1:Geo.n_elem
            ne = Geo.n(e, :);
            Xe = Geo.X(ne, :);
            for a = 1:Geo.n_nodes_elem
                if Xe(a, axis) == coord
                    t(ne, axis, t_axis) = t_value;
                end
            end
        end
    end
end