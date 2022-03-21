function vf = ref_nvec(v, n, dim)
    if length(size(v)) == 1
        vf = reshape(v, [dim, n])';
    elseif length(size(v)) == 2
        vf = zeros(n, dim, size(v,2));
        for t = 1:size(v,2)
            vf(:,:,t)=reshape(v(:,t), [dim, n])';
        end
    end
end