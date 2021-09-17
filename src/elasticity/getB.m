function B = getB(dNdx)
    n = size(dNdx,1);
    d = size(dNdx,2);
    
    B = zeros(n,d*(d+1)/2,d);

    for h = 1:n
        B(h,:,:) = [dNdx(h,1)      0         
                        0       dNdx(h,2)   
                     dNdx(h,2)   dNdx(h,1)];
    end
end