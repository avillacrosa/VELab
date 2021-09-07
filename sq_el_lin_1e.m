%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear elasticity with 1 element                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;

addpath('elasticity')
addpath('elasticity/materials')

addpath('shape')
addpath('plotters')
addpath('solvers')

x   = [ 0 0;  0 1;  1 0;  1 1];
X = x;
t   = [ 0 0;  0 0; 10 0; 10 0];

x0   = [ 1 1 0; 1 2 0; 2 1 0; 3 2 0];
dx0  = [ 1 1;  1 0;  0 1;  0 0]; 

n = [1 3 4 2];

P = [  100    0.3    1  ];

K = stiffK(x, X, P, n, 'venant');  
K = setboundsK(K, x0, n);

te = t';
te = te(:);

u = K\te(:);
u = reshape(u, [size(x,2), size(x,1)])';
femplot(X,x+u,n);
