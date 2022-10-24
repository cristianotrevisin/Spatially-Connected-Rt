function make_figure_results(R0,R1,R2,Time,data_sim,data_obs)

colors = ["#00798c", "#edae49", "#d1495b", "#08415c", "#cc2936"];

figure('Renderer', 'painters', 'Units', 'centimeters', 'Position', [1 1 12 18])

for i = 1:7
    subplot(7*2,2*2,[(1+8*(i-1)):(2+8*(i-1)) (5+8*(i-1)):(6+8*(i-1))])
    a = find(R1.Q95(i,:),1,'first');b = find(R1.Q95(i,:),1,'last');
    hold on
    filler(Time(a:b),R2.Q95(i,a:b),R2.Q05(i,a:b),colors(3),0.2);
    filler(Time(a:b),R0.Q95(i,a:b),R0.Q05(i,a:b),colors(1),0.2);
    hold off
    hold on
    p1 = plot(Time(a:b),R1.Q50(i,a:b),'color',colors(2),'linewidth',.5);
    p2 = plot(Time(a:b),R2.Q50(i,a:b),'color',colors(3),'linewidth',.75);
    p0 = plot(Time(a:b),R0.Q50(i,a:b),'color',colors(1),'linewidth',.75);
    plot(Time(a:b),ones(1,length(Time(a:b))),'color','red','linewidth',...
        .5,'LineStyle','--')
    hold off
    box off
    xlim([Time(a) Time(b)])
    if i < 7
        set(gca,'xticklabel',{[]})
    end
    if i == 1
        ylabel('VR')
    elseif i == 2
        ylabel('VI')
    elseif i == 3
        ylabel('BL')
    elseif i == 4
        ylabel('TV')
    elseif i == 5
        ylabel('VE')
    elseif i == 6
        ylabel('PD')
    elseif i == 7
        ylabel('RO')
    end                       
    if i == 1
        title('$\mathcal{R}$','interpreter','latex')
        legend([p2,p1,p0], '$\mathcal{R}^{\textrm{c}}_t \textrm{ (Eq. 1)}$',...
            '$\mathcal{R}^{\textrm{c}}_t \textrm{ (Eq. s4)}$',...
            '$\mathcal{R}^{\textrm{d}}_t$', 'interpreter', 'latex')
        legend boxoff
    end
    set(gca, 'Color', 'None') 
    ylim([0 3])
        
    subplot(7*2,2*2,[(3+8*(i-1)):(4+8*(i-1)) (7+8*(i-1)):(8+8*(i-1))])
    filler(Time(a:b),data_sim.Q95(i,a:b),data_sim.Q05(i,a:b),colors(4),0.2);
    q1 = filler(Time(a:b),data_obs(i,a:b),zeros(1,b-a+1),colors(5),0.4);
    hold on
    q2 = plot(Time(a:b),data_sim.Q50(i,a:b),'color',colors(4),'linewidth',.75);
	hold off
    xlim([Time(a) Time(b)])
    ylim([0 1.1*max(max(data_sim.Q95))])
    if i < 7
        set(gca,'xticklabel',{[]})
    end
    if i == 1
        title('$F(t)$','interpreter','latex')
        legend([q1,q2],'Observed','Simulated')
        legend boxoff
    end
    box off
    set(gca, 'Color', 'None')
end
set(findall(gcf,'-property','FontSize'),'FontSize',9)

end