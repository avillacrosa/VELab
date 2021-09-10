function [N, dNdz] = triangle(z)

    z1 = z(:,1);
    z2 = z(:,2);

    N = [1-z1-z2
         z1
         z2];

    dNdz = [ -1 -1
             1   0
             0   1];
    
end
