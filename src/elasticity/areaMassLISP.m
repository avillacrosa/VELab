function M = areaMassLISP(x, Geo, Set)
%     M = zeros(Geo.n_nodes);
    M       = zeros(Geo.n_nodes_elem^2*Geo.n_elem,1);
    M_id1   = zeros(Geo.n_nodes_elem^2*Geo.n_elem,1);
    M_id2   = zeros(Geo.n_nodes_elem^2*Geo.n_elem,1);
    c = 1;
    for e = 1:size(Geo.na,3)
        Me      = zeros(Geo.n_nodes_elem);
        Me_id1  = zeros(Geo.n_nodes_elem,1);
        Me_id2  = zeros(Geo.n_nodes_elem,1);
        for cont = 1:size(Geo.na, 1)
            nea = Geo.na(cont,2:end,e);
            nea_ref = Geo.na_ref(cont,2:end,1);
            ax  = Geo.na(cont,1,e);
            xe  = x(nea,setxor(1:Geo.dim, ax));
            for gpa = 1:size(Set.gaussPointsC,1)
                z = Set.gaussPointsC(gpa,:);
                [N, ~] = fshape(Geo.n_nodes_elem_c, z);
                [~, J] = getdNdx(xe, z, Geo.n_nodes_elem_c);
                for a = 1:Geo.n_nodes_elem_c
                    for b = 1:Geo.n_nodes_elem_c
                        Me(nea_ref(a), nea_ref(b)) = Me(nea_ref(a), nea_ref(b)) + ...
                                        N(a)*N(b)*Set.gaussWeightsC(gpa)*J;
                        Me_id1(nea_ref(a)) = nea(a);
                        Me_id2(nea_ref(b)) = nea(b);
                    end
                end
            end
        end
        for aa = 1:size(Me,1)
            for bb = 1:size(Me,2)
                M_id1(c) = Me_id1(aa);
                M_id2(c) = Me_id2(bb);
                M(c) = Me(aa,bb);
                c = c+1;
            end
        end
    end
    M = sparse(M_id1, M_id2, M);
end