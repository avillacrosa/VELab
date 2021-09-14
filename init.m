function [Topo, Material, Numerical] = init(X, x0, n, ft, P, mat_type, ...
                                        load_type, numP, num_type, visco_type, u0)
%     arguments
%         X
%         x0
%         n
%         t 
%         P
%         mat_type
%         load_type
%         numP      = []
%         num_type  = 'none'
%     end
    
    Topo      = struct();
    Material  = struct();
    Numerical = struct();
    
    Topo.x     = X;
    Topo.X     = X;
    Topo.n     = n;
    Topo.dim   = size(X,2);
    Topo.totn  = size(X,1);
    Topo.tote  = size(n,1);
    Topo.ne    = size(n,2);
    Topo.quadw = [1 1];
    Topo.quadx = [-1 1]/sqrt(3);
    Topo.x0    = x0;
    Topo.f     = ft;
    Topo.u     = u0; %Only used in maxwells viscoelasticity atm
    Topo.ftype = load_type;
    Topo.shape = 'square';
    
    Material.type = mat_type;
    Material.visco_type = visco_type;
    if strcmp(mat_type, 'hookean')
        Material.E  = P(:,1);
        Material.nu = P(:,2);
    elseif strcmp(mat_type, 'neohookean')
        Material.lambda = P(:,1);
        Material.mu     = P(:,2);
    end
    
    Numerical.type   = num_type;
    if contains(num_type, 'euler')
        Numerical.n_incr     = numP(1);
        Numerical.dt         = numP(2);
        Numerical.save       = numP(3);
        if strcmp(num_type, 'eulerf')
            Numerical.euler_type = 'forward';
        elseif strcmp(num_type, 'eulerb')
            Numerical.euler_type = 'backward';
        end
        Material.eta         = P(:,3);
    elseif strcmp(num_type, 'newton')
        Numerical.n_iter  = numP(1);
        Numerical.min_tol = numP(2);
    end
    
    
end