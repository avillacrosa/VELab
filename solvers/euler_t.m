function [sols, ts] = euler_t(xk, fx, cnt, x0, niter, dt, save)
    sols = zeros(1,niter/save);
    ts = zeros(1,niter/save);
    c = 0;
    t = 0;
    for it = 1:niter
        xkp1 = fx*xk+cnt;
        for i = 1:size(x0,1)
            n     = x0(i,1);
            dim   = x0(i,2);
            value = x0(i,3);

            if value == 0
                x_id = 2*(n-1)+dim;
                xkp1(x_id) = 0;
            end
        end
        xk = xkp1;
        t = t + dt;        
        if mod(it,save) == 0
            c = c + 1;
            sols(c) = norm(xkp1);
            ts(c) = t;
        end
    end

end
