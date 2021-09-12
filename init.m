function [Topo, Material, Numerical] = init(X, x0, n, t, P, mat_type, ...
                                        load_type, numP, num_type)
    arguments
        X
        x0
        n
        t 
        P
        mat_type
        load_type
        numP      = []
        num_type  = 'none'
    end
    
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
    Topo.f = t;
    Topo.ftype = load_type;
    Topo.shape = 'square';
    
    Material.type = mat_type;
    if strcmp(mat_type, 'hookean')
        Material.E  = P(:,1);
        Material.nu = P(:,2);
    elseif strcmp(mat_type, 'neohookean')
        Material.lambda = P(:,1);
        Material.mu     = P(:,2);
    end
    
    Numerical.type   = num_type;
    if strcmp(num_type, 'euler')
        Numerical.n_incr = numP(1);
        Numerical.dt     = numP(2);
    elseif strcmp(num_type, 'newton')
        Numerical.n_iter  = numP(1);
        Numerical.min_tol = numP(2);
    end
    
    
end