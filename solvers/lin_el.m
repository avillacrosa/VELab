function x = lin_el(x, X, ts, n, x0, dof, P, mat_type, shape_type, load_type)

    if strcmp(load_type, 'surface')
        t = integrateF(x, t, n, shape_type)
    end
    K = stiffK(x, X, P, n, mat_type, shape_type);  
    K = setboundsK(K, x0);


    u = K\t;
    u = reshape(u, [size(x,2), size(x,1)])';
    x = x + u;
end