function D = venant(P)
    E  = P(1);
    nu = P(2);
    D  = E/(1-nu^2) ... 
          *[  1  nu     0
              nu   1     0
              0   0  (1-nu)/2 ];    
end