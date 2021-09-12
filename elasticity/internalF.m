function T = internalF(Topo, Material)

    ndim   = Topo.dim;
    nnodes = Topo.totn;
    
    quadx  = Topo.quadx;
    quadw  = Topo.quadw;

    n = Topo.n;
          
    T = zeros(nnodes*ndim, 1);
    for e = 1:Topo.tote
        xe = Topo.x(n(e,:),:);
        Xe = Topo.X(n(e,:),:);
        for m = 1:size(xe,1) 
            for j = 1:size(quadw,2)
                for k = 1:size(quadw,2)
                    Fd = deformF(xe,Xe,[quadx(j),quadx(k)], Topo.shape);
                    sigma = stress(Fd, e, Material);
                    [dNdx, J] = getdNdx(xe, [quadx(j), quadx(k)], Topo.shape); 
                    int = sigma*dNdx(m,:)'*J*quadw(j)*quadw(k);
                    for ll = 1:ndim
                        idx = 2*(n(e,m)-1)+ll;
                        T(idx) = T(idx) + int(ll);
                    end
                end
            end
        end
    end
end