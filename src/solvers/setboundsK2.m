%--------------------------------------------------------------------------
% TODO
%--------------------------------------------------------------------------
function K = setboundsK2(K, Geo)
    x0 = Geo.x0;
    tot_d = Geo.dim;
    
    idx_F = Geo.dof;
    idx_B = Geo.fixdof;
    
    K_bb = K(idx_B, idx_B);
    K_fb = K(idx_F, idx_B);
    K_bf = K(idx_B, idx_F);
    K_ff = K(idx_F, idx_F);
    
    u_bc = zeros(4,1);
    for i_b = 1:size(idx_B,1)
        nb = idx_B(i_b);
        for bci = 1:size(x0,1)
            n     = x0(bci,1);
            dim   = x0(bci,2);
            value = x0(bci,3);
            bc_idx = tot_d*(n-1)+dim;
            if nb == bc_idx
                u_bc(i_b) = value;
            end
        end
    end
    u_f = K_ff\(-K_fb*u_bc+Geo.f(idx_F));
    u_f
end