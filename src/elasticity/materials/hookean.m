function sigma = hookean(Fd, Mat, dim)
    lin_str = (Fd'+Fd)/2-eye(size(Fd));
    % Ideally I would prefer computing c, then D, then sigma but that is
    % much more expensive because of looping...
    D = plane_stress(dim, Mat);
    sigma = D*vec_mat(lin_str, 2);
    sigma = ref_mat(sigma);
end