function tol = convergence(R, F, x0)
    for e = 1:size(x0,1)
        ninode= x0(e,1);
        ax    = x0(e,2);
        value = x0(e,3);

        R_id = 2*(ninode-1)+ax;

        if value == 0
            R(R_id) = 0;
        end
    end
    tol = norm(R)/norm(F);
end