function c = venant_c(Fd, Mat, dim)
    C    = zeros(dim, dim, dim, dim);
    for i = 1:dim
        for j = 1:dim
            for k = 1:dim
                for l = 1:dim
                    C(i,j,k,l) = Mat.lambda*kronD(i,j)*kronD(k,l) ...
                                 +2*Mat.mu*kronD(i,k)*kronD(j,l);
                end
            end
        end
    end
    
    c = eulerTensor(C, Fd, dim);
end