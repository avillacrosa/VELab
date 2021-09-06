clc;

addpath('elasticity')
addpath('elasticity/materials')

addpath('shape')
addpath('plotters')
addpath('solvers')

% Initial parameters, without connectivity
x   = [ 0 0;  0 1;  1 0;  1 1];   % node position
X = x;
t   = [ 0 0;  0 0; 10 0; 10 0];   % superficial load per node

x0   = [ 1 1 0; 1 2 0; 2 1 0; 3 2 0];   % Dirichlet bc
dx0  = [ 1 1;  1 0;  0 1;  0 0]; 

% Connectivity, one row for each element and one value for each node
n = [1 3 4 2];

% Material properties, one for element
P = [  100    0.3    1  ];

% --- Main ---

% Build stiffness matrix
K = stiffK(x, P, n, 'venant');  
K = setboundsK(K, x0, n);

te = t';
te = te(:);

u = K\te(:);
u = reshape(u, [size(x,2), size(x,1)])';
X, x+u
femplot(X,x+u,n);
