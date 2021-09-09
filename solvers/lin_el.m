function x = lin_el(x, X, t, n, x0, dof, P, mat_type, shape_type)
    K = stiffK(x, X, P, n, mat_type, shape_type);  
    K = setboundsK(K, x0);

    te = t';
    te = te(:);

    u = K\te(:);
    u = reshape(u, [size(x,2), size(x,1)])';
    x = x + u;
end