function PlotFits(model, texp, sexp, wexp, storexp, lossexp, p)
    p = num2cell(p);
    [Et, Ep, Epp] = GetModel(model);

    %% Plot stress data
    figure
    expdata = loglog(texp, sexp, 'ko');
    hold on
    bestfit = loglog(texp, Et(p{:}, texp)./Et(p{:},1), 'k');
    legend([bestfit, expdata], ["Experimental G(t)","Numerical G(t)"])
    xlabel("t (s)")
    ylabel("\sigma(t)")
	ax = gca;
	exportgraphics(ax,'relaxation.png','Resolution',600)
    %% Plot storage data
    figure
    expdatastor = loglog(wexp, storexp, 'bo');
    hold on
    storage = loglog(wexp, Ep(p{:}, wexp), 'b');
    xlabel("log(\omega)")
    ylabel("log(G'),log(G'')")
    
    %% Plot loss data
    expdataloss = loglog(wexp, lossexp ,'ro');
    hold on
    loss = loglog(wexp, Epp(p{:}, wexp), 'r');
    legend([expdatastor, storage, expdataloss, loss], ["Experimental G'", "Numerical G'","Experimental G''", "Numerical G''"], 'Location', 'east')
	xlim([8e-3 1.5e2])
	ax = gca;
	exportgraphics(ax,'moduli.png','Resolution',600)
end