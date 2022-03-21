function A = ref_mat(a)
    if size(a,2) > 1
        if size(a,1) == 3
            A = zeros(2, 2, size(a,2));
        elseif size(a,1) == 6
            A = zeros(3, 3, size(a,2));
        end
        for n = 1:size(a,2)
            if size(a,1) == 3
                A(:,:,n) = [a(1) a(3)
                            a(3) a(2)];
            elseif size(a,1) == 6
                A(:,:,n) = [a(1) a(4) a(5)
                            a(4) a(2) a(6)
                            a(5) a(6) a(3)];
            end
        end
    else
        if size(a,1) == 3
            A = [a(1) a(3)
                 a(3) a(2)];
        elseif size(a,1) == 6
            A = [a(1) a(4) a(5)
                 a(4) a(2) a(6)
                 a(5) a(6) a(3)];
        end
    end
end