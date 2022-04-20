clc
a = rand(2, 3, 2)
a = permute(a, [2,1,3]);
reshape(a, [size(a,1)*size(a,2),size(a,3)])
% b = reshape(a, [2, 6]);
% b = b' 