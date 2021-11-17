function M = areaMassNL(x, Geo, Set)
    M = zeros(Geo.n_nodes*Geo.dim);
    for ea = 1:size(Geo.na,1)
        nea = Geo.na(ea,:);
        xe  = x(nea(2:end),:);
        for gpa = 1:size(Set.gaussPointsC,1)
            z = Set.gaussPointsC(gpa,:);
            dxdz = getdxdz(xe, z, Geo.n_nodes_elem_c);
            [N, dNdz] = fshape(Geo.n_nodes_elem_c, z);
            
            x_zeta = dxdz(1,:);
            x_eta  = dxdz(2,:);
            n = cross(x_zeta, x_eta);
                
            ex = [1 0 0];
            ey = [0 1 0];
            
            Q = x_eta'*x_zeta-x_zeta'*x_eta;
            
            tau_x = Q*ey'/norm(Q*ey');
            tau_y = Q*ex'/norm(Q*ex');
            
            for a = 1:Geo.n_nodes_elem_c
                dNdz_eta  = dNdz(a,1);
                dNdz_zeta = dNdz(a,2);
                p_a = dNdz_eta*x_zeta-dNdz_zeta*x_eta; %Rev this;

                P_a_y = (p_a*ey')*eye(Geo.dim)+p_a'*ey;
                
                factM_x = norm(n)*(eye(Geo.dim)-tau_x*tau_x')/...
                    norm(Q*ey')*P_a_y + tau_x*(cross(n,p_a));
                factM_y = norm(n)*(eye(Geo.dim)-tau_y*tau_y')/...
                    norm(Q*ex')*P_a_x + tau_y*(cross(n,p_a));
                
                for b = 1:Geo.n_nodes_elem_c
                    nax = Geo.dim*(ne(a)-1);
                    nbx = Geo.dim*(ne(b)-1);
                    M(nax+1,nbx+1) = M(nax+1,nbx+1)+...
                                    N(b,:)*factM_x*Set.gaussWeightsC(gpa);
                    M(nax+2,nbx+2) = M(nax+1,nbx+1)+...
                                    N(b,:)*factM_y*Set.gaussWeightsC(gpa);
                end
            end
        end
    end
end

