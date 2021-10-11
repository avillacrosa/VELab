function Result = debug(Geo, Set, Mat, Result)
    K   = stiffK(Geo,Mat,Set);
    u   = zeros(size(vec_nvec(Geo.x)));
%     t_f = K(Geo.dof,Geo.fix)*u(Geo.fix)+K(Geo.dof,Geo.dof)*u(Geo.dof);
    u(Geo.dof) = K(Geo.dof,Geo.dof) \(Geo.f(Geo.dof) - K(Geo.dof,Geo.fix)*u(Geo.fix));
    Result.u = ref_nvec(u, Geo.n_nodes, Geo.dim);
    Result.x = Geo.X + Result.u;
    
    quadx = [-1 1];
    for e = 1:Geo.n_elem
        xe = Result.x(Geo.n(e,:),:);
        Xe = Geo.X(Geo.n(e,:),:);
        for i = 1:2
            for j = 1:2
                z = [quadx(i), quadx(j)];
                [sigma, ~] = material(xe, Xe, z, Mat)
            end
        end
    end
end