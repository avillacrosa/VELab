function [sigma, q] = material_v(k, x, X, q, z, Mat, Set)
    Fd   = deformF(x(:,:,k+1), X, z, size(x,1));
	Fd_n = deformF(x(:,:,k), X, z, size(x,1));
    dim = size(Fd, 1);
	if strcmpi(Mat.type, 'neomaxwell')
    	[sigma, q] = neomaxwell_S(Fd, Fd_n, q(:,:,:,k), Mat, Set, dim);
%     	[sigma, q] = neomaxwell(Fd, Fd_n, q(:,:,:,k), Mat, Set, dim);
	elseif strcmpi(Mat.type, 'neovenant')
		[sigma, q] = neovenant(Fd, Fd_n, q(:,:,:,k), Mat, Set, dim);
	end
end