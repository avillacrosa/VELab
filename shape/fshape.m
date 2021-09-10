function [N, dN] = fshape(type, z)
    if strcmp(type, 'square')
        [N, dN] = square(z);
    elseif strcmp(type, 'triangle')
        [N, dN] = triangle(z);
    end

end