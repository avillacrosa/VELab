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
K = stiffK(x, X, P, n, 'venant');  
K = setboundsK(K, x0, n);

f = t';
f = f(:);

xv = x';
xv = xv(:);

u_k = zeros(size(xv));

% Euler time integration
niter = 50;
every = 1;

str_store = zeros(1,niter/every);
t_store = zeros(1,niter/every);

eta = 1;
dt = 0.01;
wdt   = dt/eta;
tm = 0;

c = 0;

% Solve U_{k+1} = wdt*f + (1-wdt*K)u_k
[strains, times] = euler_t(u_k, ...
                        (eye(size(K))-wdt*K), wdt*f, x0, niter, dt, every);
                           

plot(times, strains)
hold on
yline(str_inf,'--')
xline(tau, '--')
ylim([0, str_inf+0.5])
hold off
