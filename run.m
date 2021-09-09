function x = run(x, n, ts, x0, P, type, mat_type, ...
                 shape_type, load_type, max_tol, n_ints, n_its)
             
    ndim   = size(x,2);
    nnodes = size(x,1);
    
    X    = x;
    %TODO I feel this could be smarter
    fix  = 2*(x0(:,1)-1)+x0(:,2);
    dof  = zeros(size(x,2)*size(x,1),1);
    dof(fix)=1;
    dof = find(dof==0);
        
    t = zeros(ndim*nnodes,1);
    for i = 1:size(ts,1)
        t(2*(ts(:,1)-1) + ts(:,2)) = ts(:,3);
    end
    if strcmp(load_type, 'surface')
        t = integrateF(x, t, n, shape_type);
    end
    
    if strcmp(type, 'linear elastic')
        x = lin_el(x, X, t, n, x0, dof, P, mat_type, shape_type);
    elseif strcmp(type, 'nonlinear elastic')
        x = nonlin_el(x, X, t, n, x0, dof, P, mat_type, ...
            shape_type, load_type, max_tol, n_its);
    elseif strcmp(type, 'linear viscoelastic')
        x = lin_ve(x, X, n, t, x0, dof, P, mat_type, shape_type);
    end
    
end