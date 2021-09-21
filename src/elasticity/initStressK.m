function K = initStressK(Geom, Material, Set)
    
    nnodes = Geom.n_nodes;
    ndim   = Geom.dim;

    K = zeros(nnodes*ndim, nnodes*ndim);
    quadw  = Set.quadw;
    quadx  = Set.quadx;
    
    for e = 1:Geom.n_elem
              
        ni = Geom.n(e,:);
        xe = Geom.x(ni,:);
        Xe = Geom.X(ni,:);
        for int_i = 1:size(quadw,2)
            for int_j = 1:size(quadw,2)

                Fd = deformF(xe,Xe,[quadx(int_i),quadx(int_j)], Geom.n_nodes_elem);
                sigma = stress(Fd, e, Material);
                [dNdx, J] = getdNdx(xe, [quadx(int_i), quadx(int_j)], Geom.n_nodes_elem);

                for ki = 1:4
                    for li = 1:4
                        nk = ni(ki);
                        nl = ni(li);
                        sl_k = (2*nk-1):2*nk;
                        sl_l = (2*nl-1):2*nl;
                        
                        K(sl_k,sl_l) = K(sl_k,sl_l)+...
                                       J*dNdx(ki,:)*sigma*dNdx(li,:)'*eye(ndim);

                    end
                end
            end
        end
    end    
end