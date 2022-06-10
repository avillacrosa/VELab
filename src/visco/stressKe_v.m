function [Ke, sigmas, qs] = stressKe_v(k, xe, Xe, qe, Geo, Mat, Set)
    Ke     = zeros(Geo.n_nodes_elem*Geo.dim, Geo.n_nodes_elem*Geo.dim);
    sigmas = zeros(Geo.vect_dim, Geo.n_nodes_elem);
	qs = zeros(Geo.vect_dim, Geo.n_nodes_elem);
    for gp = 1:size(Set.gaussPoints,1)
        z = Set.gaussPoints(gp,:);

        [sigma, q]  = material_v(k, xe, Xe, qe(:,:,gp,:), z, Mat, Set);
        [dNdx, J] = getdNdx(xe(:,:,k+1), z, Geo.n_nodes_elem);

        sigmas(:,gp) = vec_mat(sigma, 1);
		qs(:,gp)     = vec_mat(q, 1);
        for a = 1:Geo.n_nodes_elem
            for b = 1:Geo.n_nodes_elem
                sl_a_e = (Geo.dim*(a-1)+1):Geo.dim*a;
                sl_b_e = (Geo.dim*(b-1)+1):Geo.dim*b;

                Ke(sl_a_e, sl_b_e) = Ke(sl_a_e, sl_b_e)+ ...
                           J*dNdx(a,:)*sigma*dNdx(b,:)'*eye(Geo.dim)...
                                            *Set.gaussWeights(gp,:);
            end
        end
    end
end
