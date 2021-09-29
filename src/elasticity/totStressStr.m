%--------------------------------------------------------------------------
% DEPRECATED?
%--------------------------------------------------------------------------
function [stress, strain] = totStressStr(x, Topo, Material)
    quadx = Topo.quadx;
    quadw = Topo.quadw;
    strain = zeros(3,1);
    stress = zeros(3,1);
    % FIXIT : Hardcode
    E = Material.E(1);
    nu = Material.nu(1);
    for i = 1:2
        for j = 1:2
            [~, J] = getdNdx(x,[quadx(i), quadx(j)],Topo.shape)
            Fd       = deformF(x,Topo.X,[quadx(i), quadx(j)],Topo.shape);
            strain_m = (Fd'+Fd)/2-eye(size(Fd));
            strain   = strain + [strain_m(1,1); strain_m(2,2); strain_m(1,2)];
            D        =  E/(1-nu^2) ... 
                       *[  1  nu     0
                          nu   1     0
                          0   0  (1-nu)/2 ];
            stress = stress + D*strain*J*quadw(i)*quadw(j)
        end
    end
end