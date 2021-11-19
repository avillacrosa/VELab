function [Geo, Mat, Set] = tfm_nl_check(Geo, Mat, Set)
    nn = 5;
    dn = nn-1;
    Geo.ns = [nn nn 3];
    Geo.ds = [1/dn 1/dn 1/8];
    
    Geo.uBC = [ 3 0 1 0; 3 0 2 0; 3 0 3 0; 3 (nn-1)*dn 3 0];
    Geo.t   = 'output/tr_tfm_nl_05.mat';
    
    Mat.type  = 'neohookean';
    Mat.P     = [57.6923 38.4615]; 

    Set.n_steps = 1;
end