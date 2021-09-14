function Result = lin_ve(Topo, Material, Numerical)
     Result = struct();
     if strcmp(Material.visco_type, 'kelvin-voigt')
        Result = euler_kv(Topo, Material, Numerical, Result);
     elseif strcmp(Material.visco_type, 'maxwell')
        Result = euler_mx(Topo, Material, Numerical, Result);
     elseif strcmp(Material.visco_type, 'maxwell2')
        Result = euler_mx2(Topo, Material, Numerical, Result);
     end
end