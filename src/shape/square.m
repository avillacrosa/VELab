function [N, dNdz] = square(z)

    z1 = z(:,1);
    z2 = z(:,2);

    N = [(z1-1)*(z2-1)
         (z1+1)*(-z2+1)
         (z1+1)*(z2+1)
         (-z1+1)*(z2+1)]/4;

    dNdz = [ z2-1  z1-1
            -z2+1 -z1-1
             z2+1  z1+1
            -z2-1 -z1+1]/4;
    
end