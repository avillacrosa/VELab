function [N, dN] = fshape(type, z)
    if type == 4
        [N, dN] = square(z);
    elseif type == 3
        [N, dN] = triangle(z);
    end

end