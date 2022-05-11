%--------------------------------------------------------------------------
% Obtain the vectorized version of a tensor A (used for stress and strain
% for example)
%--------------------------------------------------------------------------
function vecA = vec_mat(A, fact)
    d = size(A,1);
    
    vecA = zeros(d*(d+1)/2, size(A,3));
    for i = 1:size(A,3)
        a = A(:,:,i);
        if d == 2
            veca = [a(1,1), a(2,2), fact*a(1,2)]';
        elseif d == 3
            veca = [a(1,1), a(2,2), a(3,3), ...
                    fact*a(1,2), fact*a(1,3), fact*a(2,3)]';
        end
        vecA(:,i) = veca;
    end
end