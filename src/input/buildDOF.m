function [dof, fix] = buildDOF(Geo)
   % Degrees of freedom for fast access. 
    if isfield(Geo, 'x0')
        fix          = Geo.dim*(Geo.x0(:,1)-1)+Geo.x0(:,2);
        dof          = zeros(Geo.dim*Geo.n_nodes,1);
        dof(fix)     = 1;
        dof          = find(dof==0);
    end
end