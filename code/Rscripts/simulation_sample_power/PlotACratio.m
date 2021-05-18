%%

ftmp = dir('*_para_rdm*50.csv');
allratio = [];
alltbl = [];
figure;
for ii = 1:length(ftmp)
    
    namesp = split(ftmp(ii).name, '_');
    thisname = namesp{3};
    tbltmp = readtable(ftmp(ii).name);
    alltbl.(thisname) = tbltmp;
    ratioac = (tbltmp.Estimated_a - tbltmp.Estimated_c)./(tbltmp.Estimated_a + tbltmp.Estimated_c);
    rawratio = mean((tbltmp.Simulated_a - tbltmp.Simulated_c)./(tbltmp.Simulated_a + tbltmp.Simulated_c));
%     rawdiff = mean(tbltmp.Simulated_c - tbltmp.Simulated_a);
%     mdiff = mean(-1*tbltmp.Difference);
%     
    allratio(:,ii) = ratioac;

    subplot(2,4,ii);
    histogram(ratioac(ratioac<=0), 30, 'FaceColor', 'r','EdgeColor','none') %, 'BinWidth',0.1 'Normalization', 'probability',
    hold on;
    histogram(ratioac(ratioac>0), 30, 'FaceColor', 'b', 'EdgeColor','none')
    plot([0, 0], [0, 5000], 'k--', 'linewidth', 1)
    box off
%     set(gcf,'unit','centimeters','position',[3 5 4.34 3.2])
    set(gca, 'YTick', 0:1e3:5e3, 'XTick', -1:0.5:1, 'LineWidth', 1)
%     set(gca, 'YTickLabel', {}, 'XTicklabel', {})
%     ylim([0, 5000])


end


%%

ftmp = dir('*_para_rdm*_1e3.csv');
allratio = [];
for ii = 1:length(ftmp)
    
    namesp = split(ftmp(ii).name, '_');
    thisname = namesp{3}(1:end-4);
    tbltmp = readtable(ftmp(ii).name);
    alltbl.(namesp{3}(1:end-4)) = tbltmp;
    ratioac = (tbltmp.Estimated_a - tbltmp.Estimated_c)./(tbltmp.Estimated_a + tbltmp.Estimated_c);
    rawratio = mean((tbltmp.Simulated_a - tbltmp.Simulated_c)./(tbltmp.Simulated_a + tbltmp.Simulated_c));
%     rawdiff = mean(tbltmp.Simulated_c - tbltmp.Simulated_a);
%     mdiff = mean(-1*tbltmp.Difference);
%     subplot(2,4,ii); 
    allratio(:,ii) = ratioac;
    if true
        fig = figure;
        histogram(ratioac(ratioac<=0), 30, 'FaceColor', 'r','EdgeColor','none') %, 'BinWidth',0.1 'Normalization', 'probability',
        hold on;
        histogram(ratioac(ratioac>0), 30, 'FaceColor', 'b', 'EdgeColor','none')
        plot([0, 0], [0, 5000], 'k--', 'linewidth', 1)
        box off
        set(gcf,'unit','centimeters','position',[3 5 4.34 3.2])
        set(gca, 'YTick', 0:1e3:5e3, 'XTick', -1:0.5:1, 'LineWidth', 1)
        set(gca, 'YTickLabel', {}, 'XTicklabel', {})
        ylim([0, 5000])
        saveas(fig, ['acratio_', thisname, '.emf'], 'emf')
        close all
    end
end

%%
ftmp1 = dir('*_para_tw*.csv');
ftmp2 = dir('*_para_St*.csv');
ftmp = cat(1, ftmp1, ftmp2);
allratio = [];
for ii = 1:length(ftmp)
    
    namesp = split(ftmp(ii).name, '_');
    thisname = namesp{3}(1:end-4);
    tbltmp = readtable(ftmp(ii).name);
    alltbl.(namesp{3}(1:end-4)) = tbltmp;
    ratioac = (tbltmp.Estimated_a - tbltmp.Estimated_c)./(tbltmp.Estimated_a + tbltmp.Estimated_c);
    rawratio = mean((tbltmp.Simulated_a - tbltmp.Simulated_c)./(tbltmp.Simulated_a + tbltmp.Simulated_c))
%     rawdiff = mean(tbltmp.Simulated_c - tbltmp.Simulated_a);
%     mdiff = mean(-1*tbltmp.Difference);
%     subplot(2,4,ii); 
    allratio(:,ii) = ratioac;
    if false
        fig = figure;
    histogram(ratioac(ratioac<=0), 30, 'FaceColor', 'r','EdgeColor','none') %, 'BinWidth',0.1 'Normalization', 'probability',
%     histogram(tbltmp.Difference)
    hold on; 
    histogram(ratioac(ratioac>0), 30, 'FaceColor', 'b', 'EdgeColor','none')
%     plot([rawratio, rawratio], [0,1000], 'k--', 'linewidth', 1.4)
    plot([0, 0], [0, 5000], 'k--', 'linewidth', 1)
%     plot([mdiff, mdiff], [0,1000], 'k--', 'linewidth', 1.4)
%     title(namesp{3}(1:end-4))
    ylim([0, 5000])
    box off
    % save fig as the format you want [vvv]
    set(gcf,'unit','centimeters','position',[3 5 4.34 3.2]) % set figure's position, [3 5 4.34 3.2]: [0,0] is the left bottom of the screen, 4.34 is the width, 3.2 is the height
    set(gca, 'YTick', 0:1e3:5e3, 'XTick', -1:0.5:1, 'LineWidth', 1)
    set(gca, 'YTickLabel', {}, 'XTicklabel', {})
    saveas(fig, ['acratio_', thisname, '.emf'], 'emf') % save 'fig' as emf
    close all
    end
end

%%
validx = ~isnan(allratio);

for ii = 1:7
[mean(allratio(validx(:,ii),ii)<=0), mean(allratio(validx(:,ii),ii)>0);
    mean(allratio(validx(:,ii),ii)<0), mean(allratio(validx(:,ii),ii)>=0)]


end
