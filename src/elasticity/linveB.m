function Btot = linveB(Geom, Set)
    nnodes = Geom.n_nodes;
    ndim   = Geom.dim;

    quadw  = Set.quadw;
    quadx  = Set.quadx;
    Btot = zeros(nnodes*ndim, nnodes*ndim);

    for e = 1:Geom.n_elem
        ne = Geom.n(e,:);
        xe = Geom.x(Geom.n(e,:),:);
%         Xe = Topo.X(Topo.n(e,:),:);
        for f = 1:2
            for g = 1:2
                [dNdx, J] = getdNdx(xe,[quadx(f),quadx(g)], Geom.n_nodes_elem);
                B    = getB(dNdx);
                for a = 1:4
                    for b = 1:4
                        sl_k = (2*ne(a)-1):2*ne(a);
                        sl_l = (2*ne(b)-1):2*ne(b);
                        Ba = squeeze(B(a,:,:));
                        Bb = squeeze(B(b,:,:));
                        Btot(sl_k, sl_l) = Btot(sl_k, sl_l) + ...
                                        Ba'*Bb*J*quadw(f)*quadw(g);
                    end
                end
            end
        end
    end
end