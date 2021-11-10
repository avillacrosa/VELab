%--------------------------------------------------------------------------
% Compute nodal displacement Neumann conditions given user input format
%--------------------------------------------------------------------------
function [vals, hits] = dBCtoU(Geo, dBC)
    X      = Geo.X;
    hits   = zeros(Geo.n_nodes, Geo.dim);
    vals   = zeros(Geo.n_nodes, Geo.dim);
    for plane_idx = 1:size(dBC, 1)
        axis    = dBC(plane_idx,1);
        coord   = dBC(plane_idx,2);
        t_axis  = dBC(plane_idx,3);
        t_value = dBC(plane_idx,4);
        hit_idx = X(:,axis) == coord;
        hits(hit_idx, t_axis) = 1;
        vals(hit_idx, t_axis) = t_value;
    end
    hits = logical(hits);
    vals = vals;
end