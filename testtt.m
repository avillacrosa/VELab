ts = 100;
dt = 0.01;
t = 0;
sigmas = ones(ts,1);
strains = zeros(size(sigmas));
strains2 = zeros(size(sigmas));

eta = 1; D = 1;

for k = 1:ts-1
    strains(k+1) = sigmas(k)*dt/eta+(1-D*dt/eta)*strains(k); 
    t = t + dt;
end
t=0;
for k = 2:ts
    strains2(k) = sigmas(k-1)*dt/eta+(1-D*dt/eta)*strains2(k-1); 
    t = t + dt;
end