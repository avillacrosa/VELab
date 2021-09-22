function D = mhook(E, nu, dim)
    if dim == 2
        D  = E/(1-nu^2) ... 
              *[  1  nu     0
                  nu   1     0
                  0   0  (1-nu)/2 ];    
    elseif dim == 3
        D = E/(1-nu^2) ...
            *[ 1 nu   nu     0       0       0
               nu 1   nu     0       0       0
               nu nu   1     0       0       0
               0   0   0  (1-nu)/2   0       0
               0   0   0     0    (1-nu)/2   0
               0   0   0     0       0    (1-nu)/2];
    end
end