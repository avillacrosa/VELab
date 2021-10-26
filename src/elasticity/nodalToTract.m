function M = nodalToTract(x, Geo, Set)
    % TODO this should be sparse
    M = zeros(Geo.n_nodes, Geo.n_nodes);
    for e = 1:Geo.n_elem
        ni = Geo.n(e,:);
        xe = x(Geo.n(e,:),:);
        for gp = 1:size(Set.gaussPoints,1)
            z  = Set.gaussPoints(gp, :);
            [N, ~] = fshape(Geo.n_nodes_elem, z);
            [~, J] = getdNdx(xe, z, Geo.n_nodes_elem);
            for a = 1:Geo.n_nodes_elem
                for b = 1:Geo.n_nodes_elem
                    M(ni(a),ni(b)) = M(ni(a),ni(b)) + ...
                             N(a,:)*N(b,:)*Set.gaussWeights(gp,:)*J;
                end
            end
        end
    end
end