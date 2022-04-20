function v = vec_nvec(v)
	if length(size(v))==2
		v = v';
		v = v(:);
	elseif length(size(v))==3
		v = permute(v, [2,1,3]);
		v = reshape(v, [size(v,1)*size(v,2),size(v,3)]);
	end
end