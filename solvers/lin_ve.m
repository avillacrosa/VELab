function x = lin_ve(x, X, ts, n, x0, dof, P, mat_type, ...
                    shape_type, load_type, algo_type, n_incs)
     
     [ukp1, sols, ts] = euler_t(x, X, ts, n, x0, dof, P, mat_type, ...
                    shape_type, load_type, algo_type, n_incs);
     figure
     plot(ts, sols);      
     ukp1 = reshape(ukp1, [2,4])';
     x = x + ukp1;
end