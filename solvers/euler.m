clc

x = [0, 1];
X = x;
f = [0, 10];
n = [1, 2];
P = [  1    0    1  ];

u = [0 0];
u_k = u;

% Time discretization
K0 = buildK1D(x,P,n);
K0

eta = 1;
dt = 0.01;
wdt   = dt/eta;
t = 0;

str_inf = f(2)/K0(2,2);
tau = K0(2,2)/eta;

niter = 5000;
str_store = zeros(niter);
t_store = zeros(niter);

for it = 1:niter
%     K = buildK1D(X,P,n);
    u_kp1 = u_k' + wdt*f'- wdt*K0*u_k';
    u_kp1(1) = 0;
    u_k   = u_kp1';
    
    x = x + u_k;
    t = t + dt;
    
    if it < 1000
        str_store(it) = norm(u_k);
        t_store(it) = t;
    end
end

disp(["If problem was 1D the result would be", f(2)/K0(2,2)])
disp(["Obtained", norm(u_k)])

plot(t_store, str_store)
hold on
yline(str_inf,'--')
xline(tau, '--')
ylim([0, str_inf+0.5])
