function T = integrateTractv2(x, t, Geo, Set)
    T = zeros(size(t));
    for ea = 1:size(Geo.na,1)
        nea = Geo.na(ea,:);
        xe  = x(nea(2:end),setxor(1:Geo.dim, nea(1)));
        A = Geo.dim*(nea-1)+1;
        B = Geo.dim*(nea-1)+2;
        if Geo.dim == 2
            ide = reshape([A;B], size(A,1), []);
        elseif Geo.dim == 3
            C = Geo.dim*(nea-1)+3;
            ide = reshape([A;B;C], size(A,1), []);
        end
        Te = t(nea(2:end));
        for gpa = 1:size(Set.gaussPointsC,1)
            z = Set.gaussPointsC(gpa,:);
            [N, ~] = fshape(Geo.n_nodes_elem_c, z);
            [~, J] = getdNdx(xe, z, Geo.n_nodes_elem_c);
            
            for a = 1:Geo.n_nodes_elem_c
                for d = 1:Geo.dim
                    n_id  = Geo.dim*(nea(a)-1)+d;
                    T(n_id,:) = T(n_id,:) + Te(a, :)*...
                        N(a)*Set.gaussWeightsC(gpa)*J;
                end
            end
        end
    end
end