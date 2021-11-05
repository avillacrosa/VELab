function sigma = visco(x, xp1, X, z, eta, dt, dim)
    Fd = deformF(x, X, z, 8);
    Fdp1 = deformF(xp1, X, z, 8);
    lin_str    = (Fd'+Fd)/2-eye(size(Fd));
    lin_str_p1 = (Fdp1'+Fdp1)/2-eye(size(Fdp1));
    sigma = eye(dim)*eta*(lin_str_p1-lin_str)/dt;
end
