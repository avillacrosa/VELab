function Btot = linveBmx(Geom, Set)
    nnodes = Geom.n_nodes;
    ndim   = Geom.dim;

    quadw  = Set.quadw;
    quadx  = Set.quadx;
    Btot = zeros(3, nnodes*ndim);

    for e = 1:Geom.n_elem
        ne = Geom.n(e,:);
        xe = Geom.x(Geom.n(e,:),:) + Geom.u(Geom.n(e,:),:);
        for f = 1:2
            for g = 1:2
                [dNdx, J] = getdNdx(xe,[quadx(f),quadx(g)], Geom.n_nodes_elem);
                B    = getB(dNdx);
%                 Btot(:,:) = 
                for a = 1:4
                    sl_k = (2*ne(a)-1):2*ne(a);
                    Ba = squeeze(B(a,:,:));
                    Btot(:, sl_k) = Btot(:, sl_k)+Ba*J*quadw(f)*quadw(g);
                end
            end
        end
    end
end