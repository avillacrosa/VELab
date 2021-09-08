%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear elasticity with 2 elements in triangle shape                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;

addpath('elasticity')
addpath('elasticity/materials')

addpath('shape')
addpath('plotters')
addpath('solvers')

x   = [ 0 0;  2 0;  1 1;  0 2; 2 2]/2;
X = x;
t   = [ 0 0;  10 0; 0 0 ; 0 0; 10 0];
x0   = [ 1 1 0; 1 2 0; 2 2 0; 4 1 0];

x = [  0 0 ; 1 0 ; 1 1 ; 0 1 ; 0.5 0.5 ];
X = x;
x0 = [1  1  0; 1  2  0; 2  2  0; 4  1  0];
n = [1 2 3 5; 1 5 3 4];
t   = [ 0 0;  10 0; 10 0 ; 0 0; 0 0];

% dx0  = [ 1 1;  1 0;  0 1;  0 0]; 

% Connectivity, one row for each element and one value for each node
% n = [1 3 5 4; 1 2 5 3];

P = [  100    0.3    1  ; 100    0.3    1 ];


K = stiffK(x, X, P, n, 'venant');
K = setboundsK(K, x0, n);

te = t';
te = te(:);

u = K\te(:);
u = reshape(u, [size(x,2), size(x,1)])';
femplot(X,x+u,n);
