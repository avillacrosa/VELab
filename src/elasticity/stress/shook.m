function sigma = shook(Fd, E, nu)
    strain   =  (Fd'+Fd)/2-eye(size(Fd));
    vec_strain = vectorize(strain);
    if dim == 2
        c  = E/(1-nu^2) ... 
              *[  1  nu     0
                  nu   1     0
                  0   0  (1-nu)/2 ];  
        vec_sigma = c*vec_strain;
        sigma = [vec_sigma(1) vec_sigma(3)
                 vec_sigma(3) vec_sigma(2)];
    elseif dim == 3
        c  = E/(1-nu^2) ...
            *[ 1 nu nu    0       0       0
               nu 1 nu    0       0       0
               nu nu 1    0       0       0
               0   0 0 (1-nu)/2   0       0
               0   0 0    0    (1-nu)/2   0
               0   0 0    0       0    (1-nu)/2];
        vec_sigma = c*vec_strain;
        sigma = [vec_sigma(1) vec_sigma(4) vec_sigma(5)
                 vec_sigma(4) vec_sigma(2) vec_sigma(6)
                 vec_sigma(5) vec_sigma(6) vec_sigma(3)];
    end
end