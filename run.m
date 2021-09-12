function Result = run(Topo, Material, Numerical)
    
    fix  = 2*(Topo.x0(:,1)-1)+Topo.x0(:,2);
    dof  = zeros(Topo.dim*Topo.totn,1);
    dof(fix)=1;
    dof = find(dof==0);
    Topo.dof = dof;
    
    t = zeros(Topo.dim*Topo.totn,1);
    for i = 1:size(Topo.f,1)
        t(2*(Topo.f(:,1)-1) + Topo.f(:,2)) = Topo.f(:,3);
    end
    Topo.f = t;
    
    if strcmp(Numerical.type, 'newton')
        Result = nonlin_el(Topo, Material, Numerical);
        
    elseif strcmp(Numerical.type, 'euler')
        Result = lin_ve(Topo, Material, Numerical);
        
    else 
        Result = lin_el(Topo, Material);
    end
end