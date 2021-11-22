function sigma = venant(Fd, Mat, dim)
    J    = det(Fd);
    E    = EStrain(Fd); % OK
    
    S    = Mat.lambda*trace(E)*eye(size(E)) + 2*Mat.mu*E;
    sigma = Fd*S*Fd'/J;
end