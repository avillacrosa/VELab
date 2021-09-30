%--------------------------------------------------------------------------
% Compute nodal displacement Dirichlet conditions given user input format
%--------------------------------------------------------------------------
function n_bcs = nodalBC(x, bcs)
    n_bcs = zeros(0,3);
    for plane_idx = 1:size(bcs, 1)
        axis  = bcs(plane_idx,1);
        coord = bcs(plane_idx,2);
        value = bcs(plane_idx,3);
        for n = 1:size(x,1)
            x_n = x(n,axis);
            if x_n == coord
                n_bcs(end+1,:) = [n, axis, value];
            end
        end
    end
end