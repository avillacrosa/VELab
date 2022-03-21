function linstrTot = fullLinStr2(u, Geo)
   cornerPoints = [
  -1.000000000000000  -1.000000000000000  -1.000000000000000
  -1.000000000000000  -1.000000000000000   1.000000000000000
  -1.000000000000000   1.000000000000000  -1.000000000000000
  -1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000  -1.000000000000000  -1.000000000000000
   1.000000000000000  -1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000  -1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
   linstrTot = zeros(Geo.n_nodes, Geo.vect_dim);
   x = Geo.X + ref_nvec(u, Geo.n_nodes, Geo.dim);
   u = ref_nvec(u, Geo.n_nodes, Geo.dim);
   for e = 1:Geo.n_elem
        ne = Geo.n(e,:);
        ue = u(ne,:);
        xe = x(ne,:);        
        for a = 1:Geo.n_nodes_elem
            dNdx = getdNdx(xe,cornerPoints(a,:), Geo.n_nodes_elem);
            Bs = getB(dNdx);
            Bsum = zeros();
            for b = 1:Geo.n_nodes_elem
                Bsum = Bsum + Bs(:,:,b)*ue(b,:)';
            end
            linstrTot(a,:) = Bsum;
        end
   end
end