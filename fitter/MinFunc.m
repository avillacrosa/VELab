function [min,err] = MinFunc(model, texp, stressExp, wexp, storageExp, lossExp, p0, p0_lb, p0_ub, lambdas, uselog)
    [Et, Ep, Epp] = GetModel(model);

    function err = errorfunc(p)
        p = num2cell(p);
        stressModel  = Et(p{:},texp);
        storageModel = Ep(p{:},wexp);
        lossModel    = Epp(p{:},wexp);
        
        stressModel = stressModel./Et(p{:},1);
        errStress  = lambdas(1)*(stressExp-stressModel).^2;
        if uselog
            errStorage = lambdas(2)*(log10(storageExp)-log10(storageModel)).^2;
            errLoss    = lambdas(3)*(log10(lossExp)-log10(lossModel)).^2;
        else
            errStorage = lambdas(2)*(storageExp-storageModel).^2;
            errLoss    = lambdas(3)*(lossExp-lossModel).^2;
        end
        err = sum(errStress)+sum(errStorage)+sum(errLoss);
    end
    options = optimset('Display', 'none');
    A = []; b = [];
    Aeq = []; beq = [];
    if strcmpi(model, "fmaxwell")
        nonlcon = @fmaxwellC;
    else
        nonlcon = [];
    end

    min = fmincon(@errorfunc, p0, A, b, Aeq, beq, p0_lb, p0_ub, nonlcon, options);
    err = errorfunc(min);
end