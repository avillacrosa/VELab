function [p,q] = GetModelOrder(Mat)
    if strcmpi(Mat.rheo, 'kelvin')
        p=2; q=1;
    elseif strcmpi(Mat.rheo, 'maxwell')
        p=2; q=2;
    elseif strcmpi(Mat.rheo, 'fmaxwell')
        p=-1; q=-1;
    end
end