function M = nodalToTract(x, Geo, Set)
    % TODO this should be sparse    nnodes = Geo.n_nodes;
    % TODO try catch here
%     K = zeros(nnodes*ndim, nnodes*ndim);
    
%     ll = Geo.n_nodes_elem;
    M = zeros(Geo.n_nodes);

%     M_id1 = zeros(ll^2*Geo.n_elem,1);
%     M_id2 = zeros(ll^2*Geo.n_elem,1);
%     M_val = zeros(ll^2*Geo.n_elem,1);
%     k = 1;

    for e = 1:Geo.n_elem
%         Me     = zeros(Geo.n_nodes_elem, Geo.n_nodes_elem);
%         Me_id1 = zeros(Geo.n_nodes_elem, 1);
%         Me_id2 = zeros(Geo.n_nodes_elem, 1);
        ni = Geo.n(e,:);
        xe = x(Geo.n(e,:),:);
        for gpa = 1:size(Set.gausscP,1)
            for face_i = 1:size(Set.cEq)
                contEq    = Set.cEq(face_i,:);
                cont_n    = Set.cn(face_i,:);
                
                fix     = contEq(1);
                dof     = setxor(contEq(1), 1:Geo.dim);
                
                zl          = zeros(1, Geo.dim);
                zl(dof)     = Set.gausscP(gpa,:);
                zl(fix)     = contEq(2);
                
                xle = xe(cont_n,dof);

                [N, ~] = fshape(Geo.n_nodes_elem, zl);
                [~, J] = getdNdx(xle, zl, size(cont_n,2));
                for a = 1:Geo.n_nodes_elem
                    for b = 1:Geo.n_nodes_elem
                        for d = 1:Geo.dim
                            na_e = Geo.dim*(a-1)+d;
                            nb_e = Geo.dim*(b-1)+d;

                            na = Geo.dim*(ni(a)-1)+d;
                            nb = Geo.dim*(ni(b)-1)+d;
%                             fprintf("%d %d %d \n", ni(a), ni(b));
                            if ismember(na,Geo.dof) && ismember(nb,Geo.dof)
                                M(ni(a), ni(b)) = M(ni(a), ni(b)) + ...
                                       N(a,:)*N(b,:)*Set.gausscW(gpa)*J;
                            end
                        end
                    end
                end
            end
                
%             z  = Set.gaussPoints(gp, :);
%             [N, ~] = fshape(Geo.n_nodes_elem, z);
%             [~, J] = getdNdx(xe, z, Geo.n_nodes_elem);
%             for a = 1:Geo.n_nodes_elem
%                 for b = 1:Geo.n_nodes_elem
%                     na = ni(a);
%                     nb = ni(b);
%                     % TODO repeats here
%                     Me_id1(a) = na;
%                     Me_id2(b) = nb;
% 
%                     Me(a, b) = Me(a, b)+ ...
%                            N(a,:)*N(b,:)*Set.gaussWeights(gp,:)*J;
%                 end
%             end
        end
        
%         for aa = 1:size(Me,1)
%             for bb = 1:size(Me,2)
%                 M_id1(k) = Me_id1(aa);
%                 M_id2(k) = Me_id2(bb);
%                 M_val(k) = Me(aa,bb);
%                 k = k+1;
%             end
%         end
    end
%     M = sparse(M_id1, M_id2, M_val);
end