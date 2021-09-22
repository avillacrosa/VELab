function K = setboundsK(K, Geom)
    x0 = Geom.x0;
    tot_d = Geom.dim;
    for e = 1:size(x0,1)
        n     = x0(e,1);
        dim   = x0(e,2);
        
        value = x0(e,3);
        
        if value == 0
            K_id = tot_d*(n-1)+dim;
            
            K(K_id,:) = 0;
            K(:,K_id) = 0;
            K(K_id, K_id) = 1;
        end
    end
end