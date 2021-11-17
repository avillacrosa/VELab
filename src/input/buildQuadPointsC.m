function [quadA, quadW] = buildQuadPointsC(Geo, Set)
    quadA = zeros(2^(Geo.dim-1),(Geo.dim-1));
    quadW = size(2^(Geo.dim-1),1);
    if Geo.dim == 2
        for i = 1:Set.n_quad
            quadA(i) = Set.quadx(i);
            quadW(i) = Set.quadw(i);
        end
    elseif Geo.dim == 3
        for i = 1:Set.n_quad
            for j = 1:Set.n_quad
                quadA(j+Set.n_quad*(i-1),:) = [Set.quadx(i), Set.quadx(j)];
                quadW(j+Set.n_quad*(i-1)) = Set.quadw(i)*Set.quadw(j);
            end
        end
    end
end