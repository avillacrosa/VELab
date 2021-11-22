function E = EStrain(Fd)
    E = 0.5*(Fd'*Fd-eye(size(Fd)));
end