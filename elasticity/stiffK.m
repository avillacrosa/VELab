function K = stiffK(Topo, Material)
    nnodes = Topo.totn;
    ndim   = Topo.dim;

    K = zeros(nnodes*ndim, nnodes*ndim);

    quadw = Topo.quadw;
    quadx = Topo.quadx;
    n = Topo.n;
    

    for e = 1:Topo.tote
              
        ni = n(e,:);
        xe = Topo.x(n(e,:),:);
        Xe = Topo.X(n(e,:),:);
        
        for i = 1:size(quadw,2)
            for j = 1:size(quadw,2)
                D  = material(xe, Xe, e, [quadx(i), quadx(j)], Material); 
                
                [dNdx, J] = getdNdx(xe, [quadx(i), quadx(j)], Topo.shape);

                B = getB(dNdx);

                for ki = 1:4
                    for li = 1:4
                        nk = ni(ki);
                        nl = ni(li);
                        sl_k = (2*nk-1):2*nk;
                        sl_l = (2*nl-1):2*nl;
                        Bk = squeeze(B(ki,:,:));
                        Bl = squeeze(B(li,:,:));
                        K(sl_k,sl_l) = K(sl_k,sl_l)+ ...
                                       (Bk'*D*Bl)*quadw(i)*quadw(j)*J;
                    end
                end
            end
        end
    end
end