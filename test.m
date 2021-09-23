clc
X = [0 0; 1 0; 1 1; 0 1];
x = 5*X;
Fd = deformF(x,X,[1, 1], 4);
[sigma, c] = venant(Fd, 10, 10, 2);
constD(c)