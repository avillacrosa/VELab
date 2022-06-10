function c = material_c_v(k, x, X, q, z, Mat, Set)
    Fd = deformF(x(:,:,k+1), X, z, size(x,1));
	Fd_n = deformF(x(:,:,k), X, z, size(x,1));
    dim = size(Fd, 1);
	if strcmpi(Mat.type, 'neomaxwell')
%     	c = neomaxwell_c_S(Fd, Fd_n, q, Mat, Set, dim);
    	c = neomaxwell_c(Fd, Fd_n, q, Mat, Set, dim);
	elseif strcmpi(Mat.type, 'neovenant')
		c = neovenant_c(Fd, Fd_n, q, Mat, Set, dim);
	end
end