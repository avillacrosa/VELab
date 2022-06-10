%--------------------------------------------------------------------------
% Computation of the internal in both 2D and 3D
%--------------------------------------------------------------------------
function T = internalF_v(k, x, q, Geo, Mat, Set)
    x = ref_nvec(x, Geo.n_nodes, Geo.dim);
    T = zeros(Geo.n_nodes*Geo.dim, 1);
    for e = 1:Geo.n_elem
        xe = x(Geo.n(e,:),:,:);
        Xe = Geo.X(Geo.n(e,:),:);
        for m = 1:size(xe,1) 
            int = zeros(Geo.dim, 1);
            for gp = 1:size(Set.gaussPoints,1)
                z = Set.gaussPoints(gp,:);
                [sigma, ~] = material_v(k, xe, Xe, q(:,e,gp,:), z, Mat, Set);
                if strcmpi(Mat.type,"hookean")
                    [dNdx, J] = getdNdx(Xe, z, Geo.n_nodes_elem); 
                else
                    [dNdx, J] = getdNdx(xe(:,:,k+1), z, Geo.n_nodes_elem); 
                end
                int = int + sigma*dNdx(m,:)'*J*Set.gaussWeights(gp,:);
            end
            glob_idx = (Geo.dim*(Geo.n(e,m)-1)+1):Geo.dim*Geo.n(e,m);
            T(glob_idx) = T(glob_idx) + int;
        end
    end
end