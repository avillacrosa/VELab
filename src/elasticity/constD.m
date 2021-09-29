%--------------------------------------------------------------------------
% Obtain the vectorized material tensor (2nd rank) from the spatial 
% elasticity tensor (4th rank)
%--------------------------------------------------------------------------
function D = constD(c)
    dim = size(c,1);
    
    if dim == 2
        vec     = [ 1 1; 2 2; 1 2];
        sym_vec = [ 1 1; 2 2; 2 1];
    elseif dim == 3
        vec     = [ 1 1; 2 2; 3 3; 1 2; 1 3; 2 3];
        sym_vec = [ 1 1; 2 2; 3 3; 2 1; 3 1; 3 2];
    end
    
    D = zeros(size(vec,1));
    for i = 1:size(vec,1)
        for j = i:size(vec,1)
            i_1 = cat(2, vec(i,:), vec(j,:));
            i_2 = cat(2, vec(i,:), sym_vec(j,:));
            D(i,j) = c(i_1(1), i_1(2), i_1(3), i_1(4)) + ...
                     c(i_2(1), i_2(2), i_2(3), i_2(4));
            D(j,i) = D(i,j);
        end
    end
    D = D/2;
end