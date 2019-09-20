close(figure(1));
figure(1)

Nplots = 5;
dt = (d.t(end)-d.t(1) )/(Nplots-1);

t = d.t(1);
ts = cell(Nplots,1);

nn=1;
for ii=1:Nplots
    % Go to next time
    while( nn<length(d.t) && t >= d.t(nn) )
        nn=nn+1;        
    end
    
    t = d.t(nn);
    
    plot(d.p{nn}(:,1),d.p{nn}(:,2),'color',[(ii-1)/(Nplots-1),0,(1-(ii-1)/(Nplots-1))] );
    hold on;
    ts{ii} = num2str(t);    
    t=t+dt;
end

legend(ts{:},'Location','northOutside','Orientation','horizontal');
