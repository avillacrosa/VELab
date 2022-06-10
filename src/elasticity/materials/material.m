function sigma = material(x, X, z, Mat)
    Fd = deformF(x, X, z, size(x,1));
    dim = size(Fd, 1);
	% To merge everything, dont find Fd here, but inside of every material
	% function, which is cleaner.
	if strcmpi(Mat.type, 'hookean')
    	sigma = hookean(Fd, Mat, dim);
	elseif strcmpi(Mat.type, 'neohookean')
    	sigma = neohookean(Fd, Mat, dim);
	elseif strcmpi(Mat.type, 'venant')
    	sigma = venant(Fd, Mat, dim);
end