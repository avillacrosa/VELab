%--------------------------------------------------------------------------
% General integral of the product B'*B matrix in both 2D and 3D. Used
% mainly for viscoelasticity
%--------------------------------------------------------------------------
function Btot = intBB(Geo, Set)
	Kg1 = Geo.Kg1; Kg2 = Geo.Kg2;
	ll = Geo.n_nodes_elem*Geo.dim;
	B_id1 = zeros(ll^2*Geo.n_elem,1);
	B_id2 = zeros(ll^2*Geo.n_elem,1);
	Btot = zeros(ll^2*Geo.n_elem,1);
	c = 1;
	
	for e = 1:Geo.n_elem
		ne = Geo.n(e,:);
		xe = Geo.X(Geo.n(e,:),:);
		Be = zeros(Geo.n_nodes_elem*Geo.dim, Geo.n_nodes_elem*Geo.dim);
		for gp = 1:size(Set.gaussPoints,1)
			z = Set.gaussPoints(gp,:);
			[dNdx, J] = getdNdx(xe,z, Geo.n_nodes_elem);
			B    = getB(dNdx);
			for a = 1:Geo.n_nodes_elem
				for b = 1:Geo.n_nodes_elem
					sl_k = (Geo.dim*(ne(a)-1)+1):Geo.dim*ne(a);
					sl_l = (Geo.dim*(ne(b)-1)+1):Geo.dim*ne(b);
					sl_a_e = (Geo.dim*(a-1)+1):Geo.dim*a;
					sl_b_e = (Geo.dim*(b-1)+1):Geo.dim*b;
					Ba = B(:,:,a);
					Bb = B(:,:,b);
					Be(sl_a_e, sl_b_e) = Be(sl_a_e, sl_b_e) + ...
						Ba'*Bb*J*Set.gaussWeights(gp,:);
				end
			end
		end
		% SPARSIFY HERE
	
		for aa = 1:size(Be,1)
			for bb = 1:size(Be,2)
				B_id1(c) = Kg1(aa,e);
				B_id2(c) = Kg2(bb,e);
				Btot(c) = Be(aa,bb);
				c = c+1;
			end
		end
	end
	Btot = sparse(B_id1, B_id2, Btot);
end