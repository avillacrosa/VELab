function femplot(x,u,n)
    nnodes = size(x,1);
    nelem  = size(n,1);
    size(u)
    u = reshape(u,[2,nnodes])';
    xf = x + u;
    hold on
    for e = 1:nelem
        xfe = xf(n(e,:),:);
        xe  = x(n(e,:),:);
        
        xfe  = cat(1, xfe, xfe(1,:));
        xe = cat(1, xe, xe(1,:));

        plot(xe(:,1), xe(:,2),'--*', 'color', 'blue')
        plot(xfe(:,1), xfe(:,2),'--*', 'color', 'red')

        allx = cat(1,xfe,xe);

        xlim([min(allx(:,1))-0.1 max(allx(:,1))+0.1])
        ylim([min(allx(:,2))-0.1 max(allx(:,2))+0.1])    
    end
    hold off
end

