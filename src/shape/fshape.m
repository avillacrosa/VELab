function [N, dN] = fshape(type, z)
    if type == 4
        [N, dN] = square(z);
    elseif type == 3
        [N, dN] = triangle(z);
    elseif type == 8 
        [N, dN] = cube(z);
    end

end