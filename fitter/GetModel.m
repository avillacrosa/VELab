function [Et, Ep, Epp] = GetModel(model)
    if strcmpi(model,"maxwell")
        Et  = @MaxwellEt2M;
        Ep  = @MaxwellEp2M;
        Epp = @MaxwellEpp2M;
    elseif strcmpi(model,"fmaxwell")
        Et  = @FMaxwellEt;
        Ep  = @FMaxwellEp;
        Epp = @FMaxwellEpp;
    elseif strcmpi(model,"fkelvin")
        Et  = @FKelvinEt;
        Ep  = @FKelvinEp;
        Epp = @FKelvinEpp;
    elseif strcmpi(model,"fzener")
        Et  = @FZenerEt;
        Ep  = @FZenerEp;
        Epp = @FZenerEpp;
    end
end