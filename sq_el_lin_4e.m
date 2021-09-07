%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear elasticity with 4 elements                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;

addpath('elasticity')
addpath('elasticity/materials')

addpath('shape')
addpath('plotters')
addpath('solvers')

x   = [ 0 0;  1 0;  2 0;  0 1; 1 1;  2 1; 0 2 ; 1 2; 2 2]/2;
X = x;
t   = [ 0 0;  0 0;  5 0;  0 0; 0 0; 10 0; 0 0 ; 0 0; 5 0];
x0  = [1 1 0 ; 1 2 0 ; 2 2 0 ; 3 2 0 ; 4 1 0 ; 7 1 0 ;];

n = [1 2 5 4; 2 3 6 5; 4 5 8 7; 5 6 9 8];

P = [  100    0.3    1; 100    0.3    1; 100    0.3    1; 100    0.3    1];

K = stiffK(x, X, P, n, 'venant');  
K = setboundsK(K, x0, n);

te = t';
te = te(:);

u = K\te(:);
u = reshape(u, [size(x,2), size(x,1)])';

femplot(X,x+u,n);
