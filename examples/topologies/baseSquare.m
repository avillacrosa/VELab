clc;
format long
X   = [ 0 0;  0 1;  1 0;  1 1];
x = 2*X;
n   = [1 3 4 2];
x0  = [ 1 1 0; 1 2 0; 2 1 0; 3 2 0];

P = [1 0];



wx = [-1 1]/sqrt(3);
w  = [1 1];
T = zeros(4,2);
Tt = zeros(8,1);
for a = 1:4
    for i = 1:2
        for j = 1:2
            [dNdx, J] = getdNdx('square',x(n(1,:),:),[wx(i), wx(j)]);
            Fd = deformF(x(n(1,:),:), X(n(1,:),:),[wx(i), wx(j)], 'square');
            sigma = stress(mat_type, Fd, P(e,:));
            int = sigma*dNdx(a,:)';
            T(n(1,a),:) = T(n(1,a),:) + int'*J*w(i)*w(j);
            for ll = 1:2
                iddd = 2*(n(1,a)-1)+ll;
                Tt(iddd) = Tt(iddd) + int(ll)*J*w(i)*w(j);
            end
        end
    end
end
Tt
internalF(x,X,P,n,'hookean','square')

