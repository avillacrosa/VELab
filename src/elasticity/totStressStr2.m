function [stress, strain_k, c] = totStressStr2(uk, ukp1, Geom, Mat, Set)
    quadx = Set.quadx;
    quadw = Set.quadw;
    strain = zeros(3,1);
    stress = zeros(3,1);
    
    % FIXIT : Hardcode
    E = Mat.P(1);
    nu = Mat.P(2);
        c  = E/(1-nu^2) ... 
      *[  1  nu     0
          nu   1     0
          0   0  (1-nu)/2 ];  
    eta = 1;
    
    n = Geom.n;
    
    X    = Geom.X(n(1,:),:);
    uk   = uk(n(1,:),:);
    ukp1 = ukp1(n(1,:),:);
    
    xk = X + uk;
    xkp1 = X + ukp1;
    
    Fdk   = deformF(xk,X,[2 2],Geom.n_nodes_elem);
    Fdkp1 = deformF(xkp1,X,[2 2],Geom.n_nodes_elem);
    
    strain_k   =  (Fdk'+Fdk)/2-eye(size(Fdk));
    strain_k   = [strain_k(1,1); strain_k(2,2); strain_k(1,2)];
    
    strain_kp1 = (Fdkp1'+Fdkp1)/2-eye(size(Fdkp1));
    strain_kp1   = [strain_kp1(1,1); strain_kp1(2,2); strain_kp1(1,2)];
    
    
    A = c*strain_k;
    B = eta*(strain_kp1 - strain_k)/Set.dt;
    stress = A + B;
end