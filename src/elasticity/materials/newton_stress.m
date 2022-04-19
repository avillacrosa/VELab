function sigma = newtonStress(Fd_k, Fd_kp1, Mat, Set)
    lin_str_k   = (Fd_k'+Fd_k)/2-eye(size(Fd_k));
    lin_str_kp1 = (Fd_kp1'+Fd_kp1)/2-eye(size(Fd_k));
    sigma = Mat.visco*(lin_str_kp1-lin_str_k)/Set.dt;
end