function Result = lin_ve(Topo, Material, Numerical)
     Result = struct();
     Result = euler_t(Topo, Material, Numerical, Result);
end