function K = constKfl(x, Geo, Mat, Set)
    K = zeros(Geo.n_nodes*Geo.dim);
    for e = 1:Geo.n_elem
        ne = Geo.n(e,:);
        xe = x(ne,:);
        Xe = Geo.X(ne,:);
        [Ke, Kg1, Kg2] = constKe(xe, Xe, ne, Geo, Mat, Set);
        K(Kg1, Kg2) = K(Kg1, Kg2) + Ke;
    end
end