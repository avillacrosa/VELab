function eps = lin_strain(x, X, z, n_n_e)
     Fd = deformF(x, X, z, n_n_e);
     eps = (Fd'+Fd)/2-eye(size(Fd));
end