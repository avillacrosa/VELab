function c = eulerTensor(C, Fd, dim)
    J = det(Fd);
    c = zeros(size(C));
    for i = 1:dim
        for j = 1:dim
            for k = 1:dim
                for l = 1:dim
                    for I = 1:dim
                        for J = 1:dim
                            for K = 1:dim
                                for L = 1:dim
                                    c(i,j,k,l) = c(i,j,k,l) + ...
                                    Fd(i,I)*Fd(j,J)*Fd(k,K)*Fd(l,L)*...
                                    C(I,J,K,L);
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    c = c/J;
end