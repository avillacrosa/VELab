function [N, dN] = fshape(type, z)
    
    if lower(type) == "square"
        [N, dN] = square(z);
    end

end