%--------------------------------------------------------------------------
% Compute nodal traction force Dirichlet conditions given user input format
%--------------------------------------------------------------------------
function n_bcs = nodalBCf(x, bcs)
    n_bcs  = zeros(0,3);
    n_surf = boundary(x);
    n_surf = cat(1,unique(n_surf(:)),1);
    for plane_idx = 1:size(bcs, 1)
        axis    = bcs(plane_idx,1);
        coord   = bcs(plane_idx,2);
        t_axis  = bcs(plane_idx,3);
        t_value = bcs(plane_idx,4);
        for n_s_i = 1:(size(n_surf,1)-1) % Last element is 1st
            n_s = n_surf(n_s_i);
            if x(n_s,axis) == coord
                n_bcs(end+1,:) = [n_s, t_axis, t_value];
            end
        end
    end
end