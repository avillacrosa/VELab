clc; clear all
stress  = load('stress.txt');

k = 2;
a = 0.5;

x = linspace(0,10,100);
y = x.^(k);
dx = 1e-8;

niter = 50;

og = plot(x,y);
an = plot(x, analytical(x,k,a), 'o');
hold on
num = plot((1:niter)*dx, fractional(k,a, dx, niter));

legend([an, num], ["Df analytical", "Df numerical"])

% legend([og, an, num], ["f", "Df analytical", "Df numerical"])

function Dy = analytical(x, k, a)
    Dy = gamma(k+1)/gamma(k-a+1).*x.^(k-a);
end

function Dy = fractional(k, a, dx, niter)
    Dy = zeros(niter,1);
    xs = (0:niter)*dx;
    for it = 1:(niter)
        lambda = 1;
        frac_fact = 0;
        for j = 1:(it+1)
            x = xs(it-j+2);
            frac_fact = frac_fact + lambda*(x).^(k);
%             frac_fact = frac_fact + lambda*2;

            lambda = lambda*(j-a-1)/(j);
        end
        Dy(it) = dx.^(-a)*frac_fact;
    end
end