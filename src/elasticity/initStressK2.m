function K = initStressK(Topo, Material)
    
    nnodes = Topo.totn;
    ndim   = Topo.dim;

    K = zeros(nnodes*ndim, nnodes*ndim);
    quadw  = Topo.quadw;
    quadx  = Topo.quadx;
    
    for e = 1:Topo.tote
              
        ni = Topo.n(e,:);
        xe = Topo.x(ni,:);
        Xe = Topo.X(ni,:);
        for int_i = 1:size(quadw,2)
            for int_j = 1:size(quadw,2)

                Fd = deformF(xe,Xe,[quadx(int_i),quadx(int_j)], Topo.shape);
                sigma = stress(Fd, e, Material);
                [dNdx, J] = getdNdx(xe, [quadx(int_i), quadx(int_j)], Topo.shape);

                for ki = 1:4
                    for li = 1:4
                        nk = ni(ki);
                        nl = ni(li);
                        sl_k = (2*nk-1):2*nk;
                        sl_l = (2*nl-1):2*nl;
%                         k_ab_ij = J*dNdx(ki,:)*sigma*dNdx(li,:)'*eye(ndim);
                        
                        K(sl_k,sl_l) = K(sl_k,sl_l)+...
                                       quadw(li)*quadw(ki)*J*dNdx(ki,:)*sigma*dNdx(li,:)'*eye(ndim);

                    end
                end
            end
        end
    end    
end