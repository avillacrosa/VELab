function tint = integrateF(Geom, Set)
    
    tint = zeros(size(Geom.f));
    ndim = Geom.dim;
    quadx = Set.quadx;
    quadw = Set.quadw;
    n = Geom.n;
    
    for e = 1:Geom.n_elem
        A = 2*(n(e,:)-1)+1;
        B = 2*(n(e,:)-1)+2;
        ide = reshape([A;B], size(A,1), []);
        te = Geom.f(ide);
        xe = Geom.x(n(e,:),:);
        for a = 1:Geom.n_nodes_elem
            for d = 1:ndim
                for j = 1:ndim
                    n_id  = 2*(n(e,a)-1)+d;
                    ne_id = 2*(a-1)+d;

                    [N, ~] = fshape(Geom.n_nodes_elem, [quadx(j), -1]);
                    [~, J] = getdNdx(xe, [quadx(j), -1], Geom.n_nodes_elem);
                    tint(n_id,:) = tint(n_id,:) + te(ne_id, :)*N(a)*quadw(j)*J^(1/ndim);

                    [N, ~] = fshape(Geom.n_nodes_elem, [+1, quadx(j)]);
                    [~, J] = getdNdx(xe, [+1, quadx(j)], Geom.n_nodes_elem);
                    tint(n_id,:) = tint(n_id,:) + te(ne_id, :)*N(a)*quadw(j)*J^(1/ndim);

                    [N, ~] = fshape(Geom.n_nodes_elem, [quadx(j), +1]);
                    [~, J] = getdNdx(xe, [quadx(j), +1], Geom.n_nodes_elem);
                    tint(n_id,:) = tint(n_id,:) + te(ne_id, :)*N(a)*quadw(j)*J^(1/ndim);

                    [N, ~] = fshape(Geom.n_nodes_elem, [-1, quadx(j)]);
                    [~, J] = getdNdx(xe, [-1, quadx(j)], Geom.n_nodes_elem);
                    tint(n_id,:) = tint(n_id,:) + te(ne_id, :)*N(a)*quadw(j)*J^(1/ndim);
                end
            end
        end
    end
end