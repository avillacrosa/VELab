function femplot(X,x,n)
    hold on
    for e = 1:size(n,1)
        xe = x(n(e,:),:);
        Xe  = X(n(e,:),:);
        xe  = cat(1, xe, xe(1,:));
        Xe = cat(1, Xe, Xe(1,:));

        plot(Xe(:,1), Xe(:,2),'--*', 'color', 'blue')
        plot(xe(:,1), xe(:,2),'--*', 'color', 'red')

        allx = cat(1,X,x);

        xlim([min(allx(:,1))-0.1 max(allx(:,1))+0.1])
        ylim([min(allx(:,2))-0.1 max(allx(:,2))+0.1])    
    end
    hold off
end

