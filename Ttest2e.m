clc

addpath('elasticity')
addpath('elasticity/materials')

addpath('shape')
addpath('plotters')
addpath('solvers')

w = [1 1];
wx = [-1 1]/sqrt(3);

E  = 1;
nu = 0;
P = [ E nu ];

D  = [  1    0    0
        0    1    0
        0    0  1/2 ]; 

X = [ 0 0;  1 0;  2 0;  0 1; 1 1;  2 1; 0 2 ; 1 2; 2 2];
x = 2*X;
n = [1 2 5 4; 2 3 6 5; 4 5 8 7; 5 6 9 8];

% X = [ 0 0 ; 2 0 ; 2 2 ; 0 2];
% x = 2*X;
% n = [1 2 3 4];

for e = 1:size(n,1)
    xe = x(n(e,:),:);
    Xe = X(n(e,:),:);
    Fd = deformF(xe,Xe,[1, 1]);
    strain =  (Fd'+Fd)/2-eye(size(Fd));
    sigma = stress('venant', D, strain);
    vec_s = [1; 1; 0];

    intT = zeros([size(n,1), 4     2]);
    for i = 1:2
        for j = 1:2
            [dNdx, J] = getdNdx('square', xe, [wx(i), wx(j)]);
            B = getB(dNdx);
            for k = 1:4
                Bk = squeeze(B(k,:,:));
                
                prod = Bk'*vec_s;
                size(intT(e,k,:)), size(prod')
                intT(e,k,:) = intT(e, k,:) + prod' *J*w(i)*w(j);
            end
            
        end
    end
%     break
end
intT
T = internalF(x, X, P, n, 'venant', 'square');
T

