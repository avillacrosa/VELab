function [nA, eqA, quadA, quadW] = buildAreaDep(Geo, Set)
    quadA = zeros(2^(Geo.dim-1),(Geo.dim-1));
    quadW = size(2^(Geo.dim-1),1);
    if Geo.dim == 2
        for i = 1:Set.n_quad
            quadA(i) = Set.quadx(i);
            quadW(i) = Set.quadw(i);
        end
        
        % Axis and plane
        %       bot   top   right  left
        eqA = [ 2 -1; 2  1; 1  1; 1  -1];
        nA  = [ 1  2; 4  3; 2  3; 1   4];
        
    elseif Geo.dim == 3
        for i = 1:Set.n_quad
            for j = 1:Set.n_quad
                quadA(j+Set.n_quad*(i-1),:) = [Set.quadx(i), Set.quadx(j)];
                quadW(j+Set.n_quad*(i-1)) = Set.quadw(i)*Set.quadw(j);
            end
        end
        
        % Axis and plane
        %      front   back  right   left    top     bot
        eqA = [1   1; 1  -1; 2   1; 2   -1; 3   1; 3   -1];
        nA  = [2 3 7 6; 1 4 8 5; 4 3 7 8; 1 2 6 5; 5 6 7 8; 1 2 3 4];
    end
end