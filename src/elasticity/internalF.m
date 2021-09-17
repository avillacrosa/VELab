function T = internalF(Geom, Mat, Set)

    ndim   = Geom.dim;
    nnodes = Geom.n_nodes;
    
    quadx  = Set.quadx;
    quadw  = Set.quadw;

    n = Geom.n;
          
    T = zeros(nnodes*ndim, 1);
    for e = 1:Geom.n_elem
        xe = Geom.x(n(e,:),:);
        Xe = Geom.X(n(e,:),:);
        for m = 1:size(xe,1) 
            for j = 1:size(quadw,2)
                for k = 1:size(quadw,2)
                    Fd = deformF(xe,Xe,[quadx(j),quadx(k)], Geom.n_nodes_elem);
                    sigma = stress(Fd, e, Mat);
                    [dNdx, J] = getdNdx(xe, [quadx(j), quadx(k)], Geom.n_nodes_elem); 
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