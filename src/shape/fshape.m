%--------------------------------------------------------------------------
% General function to obtain a specific set of shape functions.
%--------------------------------------------------------------------------
function [N, dN] = fshape(type, z)
    if type == 4
        [N, dN] = square(z);
    elseif type == 3
        [N, dN] = triangle(z);
    elseif type == 8 
        [N, dN] = cube(z);
    elseif type == 2
        [N, dN] = edge(z);
    end

end