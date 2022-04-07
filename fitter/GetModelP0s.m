function [p0, lb, ub] = GetModelP0s(model)
    if strcmpi(model,"maxwell")
        % K1 K2 K3 eta2 eta3
        p0 = rand(5,1)*1e4;
        ub = inf(5,1);
        lb = zeros(5,1);
    elseif strcmpi(model,"fmaxwell")
        % ca cb a b
        p0 = rand(4,1);
        p0([1,2]) = p0([1,2])*1e3;
        p0(4) = rand(1,1)*p0(3);
        ub = [Inf, Inf, 1, 1];
        lb = [0 0 0 0];
    elseif strcmpi(model,"fkelvin")
        p0 = rand(4,1);
        p0([1,2]) = p0([1,2])*1e3;
        p0(4) = rand(1,1)*p0(3);
        ub = [Inf, Inf, 1, 1];
        lb = [0 0 0 0];
    elseif strcmpi(model,"fzener")
        p0 = rand(6,1);
        p0([1,2,3]) = p0([1,2,3])*1e3;
        ub = [Inf, Inf, Inf, 1, 1, 1];
        lb = [0 0 0 0 0 0];
    end
end