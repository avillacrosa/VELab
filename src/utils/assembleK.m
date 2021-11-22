function [Kg1, Kg2] = assembleK(Geo)
    Kg1 = zeros(Geo.n_nodes_elem*Geo.dim, Geo.n_elem);
    Kg2 = zeros(Geo.n_nodes_elem*Geo.dim, Geo.n_elem);
    for e = 1:Geo.n_elem
        ne = Geo.n(e,:);
        Kg1_e = zeros(Geo.n_nodes_elem*Geo.dim, 1);
        Kg2_e = zeros(Geo.n_nodes_elem*Geo.dim, 1);
        for a = 1:Geo.n_nodes_elem
            for b = 1:Geo.n_nodes_elem
                sl_a_e = (Geo.dim*(a-1)+1):Geo.dim*a;
                sl_b_e = (Geo.dim*(b-1)+1):Geo.dim*b;

                sl_a = (Geo.dim*(ne(a)-1)+1):Geo.dim*ne(a);
                sl_b = (Geo.dim*(ne(b)-1)+1):Geo.dim*ne(b);

                Kg1_e(sl_a_e) = sl_a;
                Kg2_e(sl_b_e) = sl_b;
            end
        end
        Kg1(:, e) = Kg1_e;
        Kg2(:, e) = Kg2_e;
    end
end