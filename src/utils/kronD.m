%--------------------------------------------------------------------------
% Kronecker Delta. For some reason, faster than Matlab's version...
%--------------------------------------------------------------------------
function v = kronD(i,j)
    if i==j
        v = 1;
    else
        v = 0;
    end
end