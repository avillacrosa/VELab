function [K, R] = setboundsNL(K, R, x0, dx0, n)
    for n = 1:size(x0)
        x = x0(n,1);
        y = x0(n,2);
        if x == 1
            K((2*n-1),:) = 0;
            K(:,(2*n-1)) = 0;
            R((2*n-1)) = 0;
        end
        if y == 1 
            K(2*n,:) = 0;
            K(:,2*n) = 0;
            R((2*n)) = 0;
        end
    end
end