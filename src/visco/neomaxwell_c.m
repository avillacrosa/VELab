function c = neomaxwell_c(Fd, Fd_n, q, Mat, Set, dim)
    J = det(Fd);
    lp = Mat.lambda/J;
    mp = (Mat.mu-Mat.lambda*log(J))/J;
    
    c = zeros(dim, dim, dim, dim);
    
	for i = 1:dim
    	for j = 1:dim
        	for k = 1:dim
            	for l = 1:dim
                	c(i,j,k,l) = lp*kronD(i,j)*kronD(k,l) ...
                    	+ 2*mp*kronD(i,k)*kronD(j,l);
            	end
        	end
    	end
	end
	tau = Mat.visco/Mat.E;
	xi = -Set.dt/(2*tau);
% 	c = c*(1+exp(xi));
	c = c*(exp(xi));
	
% 	c = c*(1-exp(2*xi))/(Set.dt/tau);
end