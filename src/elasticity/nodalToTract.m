function M = nodalToTract(x, Geo, Set)
    % TODO this should be sparse    nnodes = Geo.n_nodes;
    ndim   = Geo.dim;

    % TODO try catch here
%     K = zeros(nnodes*ndim, nnodes*ndim);
    
    ll = Geo.n_nodes_elem;
    M_id1 = zeros(ll^2*Geo.n_elem,1);
    M_id2 = zeros(ll^2*Geo.n_elem,1);
    M_val = zeros(ll^2*Geo.n_elem,1);
    k = 1;

    for e = 1:Geo.n_elem
        Me     = zeros(Geo.n_nodes_elem, Geo.n_nodes_elem);
        Me_id1 = zeros(Geo.n_nodes_elem, 1);
        Me_id2 = zeros(Geo.n_nodes_elem, 1);
        
        ni = Geo.n(e,:);
        xe = x(Geo.n(e,:),:);
        for gp = 1:size(Set.gaussPoints,1)
            z  = Set.gaussPoints(gp, :);
            [N, ~] = fshape(Geo.n_nodes_elem, z);
            [~, J] = getdNdx(xe, z, Geo.n_nodes_elem);
            for a = 1:Geo.n_nodes_elem
                for b = 1:Geo.n_nodes_elem
                    na = ni(a);
                    nb = ni(b);
                    % TODO repeats here
                    Me_id1(a) = na;
                    Me_id2(b) = nb;

                    Me(a, b) = Me(a, b)+ ...
                           N(a,:)*N(b,:)*Set.gaussWeights(gp,:)*J;
                end
            end
        end
        
        for aa = 1:size(Me,1)
            for bb = 1:size(Me,2)
                M_id1(k) = Me_id1(aa);
                M_id2(k) = Me_id2(bb);
                M_val(k) = Me(aa,bb);
                k = k+1;
            end
        end
    end
    
    M_id1 = M_id1(M_id1>0);
    M_id2 = M_id2(M_id2>0);
    M_val = M_val(M_val>0);
    M = sparse(M_id1, M_id2, M_val);
end