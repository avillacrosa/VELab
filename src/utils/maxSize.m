function s = maxSize(Geo)
    num_size = 8; % Matrices are usually doubles (8 bytes)
    s = (Geo.n_nodes*Geo.dim)^2*num_size;
    s = s*10^-9; % To GB
end