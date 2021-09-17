addpath(genpath('src'))

X  = [0 0; 1 0; 1 1; 0 1];
x = 2*X;
x  = [0 0; 1.1 0; 1.3 0.86; 0 0.56];

n = [1 2 3 4];
t = [0 0; 10 0; 10 0; 0 0];

Mat = struct();
Mat.P = [100 0.3];
Mat.type = 'hookean'

quadw = [1 1];
quadx = [-1 1]/sqrt(3);

sigma_interp = zeros(4,3);
          
c = 1;
for j = 1:2
    for k = 1:2
        Fd = deformF(x,X,[quadx(j),quadx(k)], 4);
        sigma = stress(Fd, 1, Mat);
        sigma_interp(c,:) = [sigma(1,1);sigma(2,2);sigma(1,2)]';
        c = c+1;
    end
end

M = zeros(4);
bm = zeros(4,1);
for i = 1:2
    for j = 1:2
        z = [quadx(i), quadx(j)];
        Ns = square(z);
        for a = 1:4
            for b = 1:4
                M(a,b)=M(a,b)+Ns(a)*Ns(b);
            end
            bm(a) = bm(a) + Ns(a);
        end
    end
end
