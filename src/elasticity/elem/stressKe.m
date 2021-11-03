function [Ke, Kg1, Kg2] = stressKe(xe, Xe, ne, Geo, Mat, Set)
    Ke  = zeros(Geo.n_nodes_elem*Geo.dim, Geo.n_nodes_elem*Geo.dim);
    Kg1 = zeros(Geo.n_nodes_elem*Geo.dim, 1);
    Kg2 = zeros(Geo.n_nodes_elem*Geo.dim, 1);
    for gp = 1:size(Set.gaussPoints,1)
        z = Set.gaussPoints(gp,:);

        [sigma, ~] = material(xe, Xe, z, Mat);
        [dNdx, J] = getdNdx(xe, z, Geo.n_nodes_elem);

        for a = 1:Geo.n_nodes_elem
            for b = 1:Geo.n_nodes_elem
                sl_a_e = (Geo.dim*(a-1)+1):Geo.dim*a;
                sl_b_e = (Geo.dim*(b-1)+1):Geo.dim*b;
                
                sl_a = (Geo.dim*(ne(a)-1)+1):Geo.dim*ne(a);
                sl_b = (Geo.dim*(ne(b)-1)+1):Geo.dim*ne(b);

                Ke(sl_a_e, sl_b_e) = Ke(sl_a_e, sl_b_e)+ ...
                           J*dNdx(a,:)*sigma*dNdx(b,:)'*eye(Geo.dim)...
                                            *Set.gaussWeights(gp,:);
                   
                Kg1(sl_a_e) = sl_a;
                Kg2(sl_b_e) = sl_b;
            end
        end
    end
end
