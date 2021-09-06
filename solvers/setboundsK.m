function K = setboundsK(K, x0, n)
    k = 10^6*max(abs(diag(K)));
    for e = 1:size(x0,1)
%         disp(x0(e,:))
        n     = x0(e,1);
        dim   = x0(e,2);
        
        value = x0(e,3);
        
        if value == 0
            K_id = 2*(n-1)+dim;
            
            K(K_id, K_id) = K(K_id, K_id) + k;
        end
%         K_idx = 2*nni-1;
%         K_idy = 2*nni;
%         
%         ni = n(e,:);
%         x0e = x0(n(e,:),:);
%         for ii = 1:4
%             nni = ni(ii); 
%             
%             K_idx = 2*nni-1;
%             K_idy = 2*nni;
%             
%             if x0e(ii,1) == 1 %
%                 K(K_idx, K_idx) = K(K_idy, K_idy) + k;
%             end
%             if x0e(ii,2) == 1
%                 K(K_idy, K_idy) = K(K_idy, K_idy) + k;
%             end
%         end
    end
end