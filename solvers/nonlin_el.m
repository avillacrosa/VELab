function Result = nonlin_el(Topo, Material, Numerical)
    Result = struct();
    Result = newton(Topo, Material, Numerical);
end