function Btot = linveBmx(Topo)
    nnodes = Topo.totn;
    ndim   = Topo.dim;

    quadw  = Topo.quadw;
    quadx  = Topo.quadx;
    Btot = zeros(3, nnodes*ndim);

    for e = 1:Topo.tote
        ne = Topo.n(e,:);
        xe = Topo.x(Topo.n(e,:),:) + Topo.u(Topo.n(e,:),:);
        for f = 1:2
            for g = 1:2
                [dNdx, J] = getdNdx(xe,[quadx(f),quadx(g)], Topo.shape);
                B    = getB(dNdx);
                for a = 1:4
                    sl_k = (2*ne(a)-1):2*ne(a);
                    Ba = squeeze(B(a,:,:));
                    Btot(:, sl_k) = Btot(:, sl_k)+Ba*J*quadw(f)*quadw(g);
                end
            end
        end
    end
end