function Result = euler_t(Topo, Material, Numerical, Result)
    
    
    K = stiffK(Topo, Material);
%     Fd = deformF(x,X,[-1,1], shape_type);
%     sigma_0 = stress(mat_type, Fd, P(1,:))
%     e_str = norm(K)/norm(ts)
%     K = setboundsK(K,x0);
    
    % TODO Save this as arguments...
    save = 1;
    dt   = 0.0001;
    eta  = 1;
    
    sols  = zeros(1,Numerical.n_incr/save);
    times = zeros(1,Numerical.n_incr/save);
    c = 0;
    t = 0;
    uk = zeros(size(Topo.x(:)));
    Topo.f = integrateF(Topo);
    sigma_old = zeros(2,2);
    for it = 1:Numerical.n_incr
        
        Btot = linveB(Topo);
        
        stepMatrix = Btot-(dt/eta)*K;
        stepMatrix = setboundsK(stepMatrix, Topo.x0);
        Btotbc = setboundsK(Btot, Topo.x0);
        
        ukp1 = Btotbc\(stepMatrix*uk+Topo.f*(dt/eta));
        
        t = t + dt;      
        
        if mod(it,save) == 0
            c = c + 1;
            
%             [dNdx, J] = getdNdx(shape_type, x, [1 1]);
%             Bsss = getB(dNdx);
%             usrs = reshape(uk, [2,4])';
%             usrkp1= reshape(ukp1, [2,4])';
%             D = material(mat_type, x, X, [1 1], P);
%             sigma_ns = zeros(4,2,2);
%             for iii = 1:4
%                 strain_n = squeeze(Bsss(iii,:,:))*usrs(iii,:)';
%                 sigma_n = D*strain_n+eta*squeeze(Bsss(iii,:,:))...
%                           *(usrkp1(iii,:)'-usrs(iii,:)')/dt;
%                 sigma_ns(iii,:,:) = [sigma_n(1) sigma_n(3)
%                            sigma_n(3) sigma_n(2)];
%             end
%             sigmf = squeeze(sum(sigma_ns,1));
%             sigmf - sigma_old
%             
%             sigma_old = squeeze(sum(sigma_ns,1));
%             
%             strain_n = 
            
%             return
%             sols(c) = norm(strain_n);
%             times(c) = t;
        end 
        uk = ukp1;
    end
    Result.K = K;
    Result.u = uk;
    Result.x = Topo.x + reshape(ukp1, [Topo.dim,Topo.totn])';
end
