%--------------------------------------------------------------------------
% Compute nodal displacement Neumann conditions given user input format
%--------------------------------------------------------------------------
function [vals, hits] = BCtoNodal(Geo, BC)
    X      = Geo.X;
    hits   = zeros(Geo.n_nodes, Geo.dim);
    vals   = zeros(Geo.n_nodes, Geo.dim);
    for plane_idx = 1:size(BC, 1)
        axis    = BC(plane_idx,1);
        coord   = BC(plane_idx,2);
        t_axis  = BC(plane_idx,3);
        t_value = BC(plane_idx,4);
        hit_idx = X(:,axis) == coord;
        hits(hit_idx, t_axis) = 1;
        vals(hit_idx, t_axis) = t_value;
    end
    hits = repmat(hits, [1,1,length(Geo.times)]);
    vals = repmat(vals, [1,1,length(Geo.times)]);
    hits = logical(hits);
end