clc
X = [0 0; 1 0; 1 1; 0 1];
x = X;
x_s = 1.2;
y_s = 0.94;
x(:,1) = X(:,1)*x_s;
x(:,2) = X(:,2)*y_s;

Mat = struct();
Mat.type = "hookean";
Mat.P    = [57.6923 38.4615];

quadx = [-1 1]/sqrt(3);
quadw = [1 1];
for i = 1:2
    for j = 1:2
        z = [quadx(i), quadx(j)];
        Fd = deformF(x,X,z,4);
        [stress,~] = material(x,X,z,Mat);
        
        [N, dN] = fshape(4, z);
        [dNdx, J] = getdNdx(x, z, 4);
        N(2,:), dNdx(2,:);
        integrateF2D(
    end
end