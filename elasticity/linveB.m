function Btot = linveB(Topo)
    nnodes = Topo.totn;
    ndim   = Topo.dim;

    quadw  = Topo.quadw;
    quadx  = Topo.quadx;
    Btot = zeros(nnodes*ndim, nnodes*ndim);

    for e = 1:Topo.tote
        ne = Topo.n(e,:);
        xe = Topo.x(Topo.n(e,:),:);
%         Xe = Topo.X(Topo.n(e,:),:);
        for f = 1:2
            for g = 1:2
                size(Topo.x)
                [dNdx, J] = getdNdx(xe,[quadx(f),quadx(g)], Topo.shape);
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