function vecA = vectorize(A)
    d = size(A,1);
    vecA = zeros(d*(d+1)/2);
    c = 0;
    for i = 1:ndim
        for j = i:ndim
            c = c + 1;
            vecA(c) = A(i,j);
    
end