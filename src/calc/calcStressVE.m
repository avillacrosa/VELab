function stress_t = calcStressVE(u_t, stress_t, Geo, Mat, Set)
   cornerPoints = [
  -1.000000000000000  -1.000000000000000  -1.000000000000000
  -1.000000000000000  -1.000000000000000   1.000000000000000
  -1.000000000000000   1.000000000000000  -1.000000000000000
  -1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000  -1.000000000000000  -1.000000000000000
   1.000000000000000  -1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000  -1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
    lin_str = fullLinStr1(u_t(:,Mat.p), Geo);
    lin_str2 = fullLinStr1(u_t(:,1), Geo);
%     if strcmpi(Mat.rheo, 'kelvin')
    D = [   1     Mat.nu  Mat.nu       0          0         0
             Mat.nu      1    Mat.nu       0          0         0
             Mat.nu   Mat.nu     1         0          0         0
                0        0       0    (1-Mat.nu)/2    0         0
                0        0       0         0    (1-Mat.nu)/2    0
                0        0       0         0          0    (1-Mat.nu)/2]*Mat.E/(1-Mat.nu^2);


    stress_t = D*lin_str'+Mat.visco*(lin_str2'-lin_str')/Set.dt;
    stress_t = stress_t';
%     elseif strcmpi(Mat.rheo, 'maxwell')
%         D = [   1     Mat.nu  Mat.nu       0          0         0
%              Mat.nu      1    Mat.nu       0          0         0
%              Mat.nu   Mat.nu     1         0          0         0
%                 0        0       0    (1-Mat.nu)/2    0         0
%                 0        0       0         0    (1-Mat.nu)/2    0
%                 0        0       0         0          0    (1-Mat.nu)/2]*Mat.E/(1-Mat.nu^2);
%         sigma = hookean(Fs(:,:,1), Mat, dim)-hookean(Fs(:,:,2), Mat, dim) + ...
%                 ref_mat((eye(size(D))-D*Set.dt)*stress_t(:,:,1)'/Mat.visco);
%     end
%     stress_t = zeros(Geo.n_nodes, Geo.vect_dim);
%     for e = 1:Geo.n_elem
%         ne   = Geo.n(e,:);
%         x_t  = ref_nvec(vec_nvec(Geo.X)+u_t,Geo.n_nodes, Geo.dim);
%         x_te = x_t(ne,:,:);
%         Xe = Geo.X(ne,:);
%         stress_ne = zeros(Geo.n_nodes_elem, Geo.vect_dim);
%         stress_ne_t = stress_t(ne,:,:);
%         for gp = 1:size(cornerPoints,1)
%             z = Set.gaussPoints(gp,:);
%             sigma = viscomaterial(x_te, Xe, stress_ne_t(gp,:,:), z, Mat, Set);
%             stress_ne(gp,:) = vec_mat(sigma, 1);
%         end
%         stress_t(ne,:) = stress_ne;
%     end
end