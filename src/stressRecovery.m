clc

addpath(genpath('src'))

X  = [0 0; 1 0; 1 1; 0 1];
% x  = [0 0; 20 0; 10 5; 0 5];
x = 5*X;
n = [1 2 3 4];      

Mat = struct();
Mat.P = [1 0];
Mat.type = 'hookean';

quadw = [1 1];
quadx = [-1 1]/sqrt(3);


sigma_interp = zeros(4,3);

for inti = 1:2
    for intj = 1:2
        Fd = deformF(x,X,[quadx(inti), quadx(intj)], 4);
        sigma = stress(Fd,1,Mat);
        sigma_interp(2*(inti-1)+intj,:) = [sigma(1,1);sigma(2,2);sigma(1,2)]';
    end
end

M = zeros(4,4);
b = zeros(4,3);
for inti = 1:2
    for intj = 1:2
        z = [quadx(inti), quadx(intj)];
        Ns = square(z);
        for a = 1:4
            for c = 1:4
                M(a,c) = M(a,c) + Ns(a)*Ns(c);
            end
            b(a,:) = b(a,:) + Ns(a)*sigma_interp(2*(inti-1)+intj,:);
        end
    end
end
sigmas = M \ b;