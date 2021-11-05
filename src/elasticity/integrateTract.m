function T = integrateTract(t, Geo, Set)
    T = zeros(size(t));
    n = Geo.n;
    for e = 1:Geo.n_elem
        A = Geo.dim*(n(e,:)-1)+1;
        B = Geo.dim*(n(e,:)-1)+2;
        if Geo.dim == 2
            ide = reshape([A;B], size(A,1), []);
        elseif Geo.dim == 3
            C = Geo.dim*(n(e,:)-1)+3;
            ide = reshape([A;B;C], size(A,1), []);
        end
        Te = t(ide);
        xe = Geo.X(n(e,:),:);
        for gpa = 1:size(Set.gausscP,1)
            for face_i = 1:size(Set.cEq)
                contEq    = Set.cEq(face_i,:);
                cont_n  = Set.cn(face_i,:);
                
                fix     = contEq(1);
                dof     = setxor(contEq(1), 1:Geo.dim);
                
                zl          = zeros(1, Geo.dim);
                zl(dof)     = Set.gausscP(gpa,:);
                zl(fix)     = contEq(2);
                
                xle = xe(cont_n,dof);

                [N, ~] = fshape(Geo.n_nodes_elem, zl);
                [~, J] = getdNdx(xle, zl, size(cont_n,2));
                for a = 1:Geo.n_nodes_elem
                    for d = 1:Geo.dim
                        n_id  = Geo.dim*(n(e,a)-1)+d;
                        ne_id = Geo.dim*(a-1)+d;
                        T(n_id,:) = T(n_id,:) + Te(ne_id, :)*...
                            N(a)*Set.gausscW(gpa)*J;
                    end
                end
            end
        end
    end
end