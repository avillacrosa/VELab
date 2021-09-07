clc;

addpath('elasticity')
addpath('elasticity/materials')

addpath('shape')
addpath('plotters')
addpath('solvers')

x = [0; 1];
X = x;
f = [0; 10];
n = [1, 2];
P = [  1    0    1  ];

u = [0 0];
u_k = u;

% Time discretization
K0 = stiffK1D(x, X, P, n, 'venant');
eta = 1;
dt = 0.1;
wdt   = dt/eta;
t = 0;

str_inf = f(2)/K0(2,2);
tau = K0(2,2)/eta;

niter = 500;
every = 5;

str_store = zeros(1,niter/every);
t_store = zeros(1,niter/every);

c = 0;
for it = 1:niter
    u_kp1 = u_k' + wdt*f'- wdt*K0*u_k';
    u_kp1(1) = 0;
    u_k   = u_kp1';
    
    x = x + u_k;
    t = t + dt;
    
    if mod(it,every) == 0
        c = c + 1;
        str_store(c) = norm(u_k);
        t_store(c) = t;
    end
end

disp(["Expected", str_inf, "Obtained", norm(u_k)])

plot(t_store, str_store)
hold on
yline(str_inf,'--')
xline(tau, '--')
ylim([0, str_inf+0.5])
