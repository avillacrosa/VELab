function [K, K_id1, K_id2] = constKsp(x, Geo, Mat, Set)
    ll = Geo.n_nodes_elem*Geo.dim;
    K_id1 = zeros(ll^2*Geo.n_elem,1);
    K_id2 = zeros(ll^2*Geo.n_elem,1);
    K = zeros(ll^2*Geo.n_elem,1);
    c = 1;
    for e = 1:Geo.n_elem
        ne = Geo.n(e,:);
        xe = x(ne,:);
        Xe = Geo.X(ne,:);
        [Ke, Kg1, Kg2] = constKe(xe, Xe, ne, Geo, Mat, Set);
        for aa = 1:size(Ke,1)
            for bb = 1:size(Ke,2)
                K_id1(c) = Kg1(aa);
                K_id2(c) = Kg2(bb);
                K(c) = Ke(aa,bb);
                c = c+1;
            end
        end
    end
    K = sparse(K_id1, K_id2, K);
end