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

tint = zeros(8,1);
t = zeros(size(tint));
t(3) = 10;
t(5) = 10;

ndim = 2;
quadx = [-1 1]/sqrt(3);
quadw = [1 1];
n = 4;
N = [1 2 3 4];

for j = 1:2
    bot   = [quadx(j), -1];
    top   = [quadx(j), +1];
    left  = [-1, quadx(j)];
    right = [+1, quadx(j)];

    points = [bot; top; left; right];

    for face_i = 1:size(points,1)
        z = points(face_i,:);
        [N, ~] = fshape(4, z);
        [~, J] = getdNdx(x, z, 4);
        [~, JJ] = getdNdx([x(1); x(3)], quadx(j), 2)
        [~, JJ] = getdNdx([x(6); x(8)], quadx(j), 2)

        for a = 1:4
            for d = 1:2
                n_id  = 2*(a-1)+d;
                ne_id = n_id;
                tint(n_id,:) = tint(n_id,:) + ...
                    t(ne_id, :)*N(a)*quadw(j)*J^((ndim-1)/ndim);
            end
        end        
    end
end

% J, x_s/2, x_s*y_s/4