function sigma = svenant(Fd, P)
    E  = P(1);
    nu = P(2);
    c  = E/(1-nu^2) ... 
          *[  1  nu     0
              nu   1     0
              0   0  (1-nu)/2 ];  
    
    strain   =  (Fd'+Fd)/2-eye(size(Fd));
    vec_strain = vectorize(strain);
    vec_sigma = c*vec_strain;
    sigma = [vec_sigma(1) vec_sigma(3)
             vec_sigma(3) vec_sigma(2)];
end