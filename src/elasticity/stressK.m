function K = stressK(x, Geo, Mat, Set)
    Kg1 = Geo.Kg1; Kg2 = Geo.Kg2;
    if Set.sparse
        ll = Geo.n_nodes_elem*Geo.dim;
        K_id1 = zeros(ll^2*Geo.n_elem,1);
        K_id2 = zeros(ll^2*Geo.n_elem,1);
        K = zeros(ll^2*Geo.n_elem,1);
        c = 1;
        for e = 1:Geo.n_elem
            ne = Geo.n(e,:);
            xe = x(ne,:);
            Xe = Geo.X(ne,:);
            if ~strcmpi(Mat.type, 'hookean') || e == 1
                Ke = stressKe(xe, Xe, Geo, Mat, Set);
            end
            for aa = 1:size(Ke,1)
                for bb = 1:size(Ke,2)
                    K_id1(c) = Kg1(aa,e);
                    K_id2(c) = Kg2(bb,e);
                    K(c) = Ke(aa,bb);
                    c = c+1;
                end
            end
        end
        K = sparse(K_id1, K_id2, K);
    else
        K   = zeros(Geo.n_nodes*Geo.dim);
        for e = 1:Geo.n_elem
            ne = Geo.n(e,:);
            xe = x(ne,:);
            Xe = Geo.X(ne,:);
            if ~strcmpi(Mat.type, 'hookean') || e == 1
                Ke = stressKe(xe, Xe, Geo, Mat, Set);
            end
            K(Kg1(:,e), Kg2(:,e)) = K(Kg1(:,e), Kg2(:,e)) + Ke;
        end
    end
end