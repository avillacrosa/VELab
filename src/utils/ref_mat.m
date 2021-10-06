function A = ref_mat(a)
    if size(a,1) == 3
        A = [a(1) a(3)
             a(3) a(2)];
    elseif size(a,1) == 6
        A = [a(1) a(4) a(5)
             a(4) a(2) a(6)
             a(5) a(6) a(3)];
    end
end