function linstrTot = fullLinStr1(u, k, Geo)
   cornerPoints = [
   -1.000000000000000  -1.000000000000000  -1.000000000000000
   -1.000000000000000  -1.000000000000000   1.000000000000000
   -1.000000000000000   1.000000000000000  -1.000000000000000
   -1.000000000000000   1.000000000000000   1.000000000000000
    1.000000000000000  -1.000000000000000  -1.000000000000000
    1.000000000000000  -1.000000000000000   1.000000000000000
    1.000000000000000   1.000000000000000  -1.000000000000000
    1.000000000000000   1.000000000000000   1.000000000000000];
    linstrTot = zeros(Geo.n_nodes, Geo.vect_dim);
    x = Geo.X + ref_nvec(u(:,k), Geo.n_nodes, Geo.dim);
    for e = 1:Geo.n_elem
        ne = Geo.n(e,:);
        xe = x(ne,:);
        Xe = Geo.X(ne,:);
        % Iterate for every node of the element
        for a = 1:Geo.n_nodes_elem
            % Select the coordinates of the node in reference space
            Fd = deformF(xe, Xe, cornerPoints(a,:), Geo.n_nodes_elem);
            linStr = (Fd'+Fd)/2-eye(size(Fd));
            linstrTot(ne(a),:) = vec_mat(linStr,1);
        end
    end
end