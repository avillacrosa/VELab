function stress_t = calcStress(x, Geo, Mat, Set)
    stress_t = zeros(Geo.n_nodes, Geo.vect_dim);
    % INITIAL STRAIN CASE
    for e = 1:Geo.n_elem
        ne = Geo.n(e,:);
        xe = x(ne,:);
        Xe = Geo.X(ne,:);
        stress_ne = zeros(Geo.n_nodes_elem, Geo.vect_dim);
%         for a = 1:Geo.n_nodes_elem
        for gp = 1:size(Set.gaussPoints,1)
            z = Set.gaussPoints(gp,:);
            sigma = material(xe, Xe, z, Mat);
            stress_ne(gp,:) = vec_mat(sigma, 1);
        end
%         end
        stress_t(ne,:) = recoverNodals(stress_ne, Geo, Set);
    end
end