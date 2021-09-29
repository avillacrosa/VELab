%--------------------------------------------------------------------------
% Obtain the vectorized version of a tensor A (used for stress and strain
% for example)
%--------------------------------------------------------------------------
function vecA = vectorize(A)
    d = size(A,1);
    vecA = zeros(d*(d+1)/2, 1);
    %TODO generalize this ?
    if d == 2
        vecA = [A(1,1), A(2,2), A(1,2)]';
    elseif d == 3
        vecA = [A(1,1), A(2,2), A(3,3), A(1,2), A(1,3), A(2,3)]';
    end
end