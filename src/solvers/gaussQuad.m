%--------------------------------------------------------------------------
% Different Gaussian quadrature points and weights 
%--------------------------------------------------------------------------
function [quadx, quadw] = gaussQuad(n_points)
    switch n_points
        case 1
            quadx = 0;
            quadw = 2;
        case 2
            quadx = [-1 +1]/sqrt(3);
            quadw = [+1 +1];
        case 3
            quadx = [-1 0 +1]*sqrt(3/5);
            quadw = [5 8 5]/9;
    end
end