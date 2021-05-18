%% PLOT
load('res1e3.mat') % powerrdm, powertw, powerst

plotRDM = {
    'diffA'    
    'mconfA'   
    'mrtA'   
    'stdrtA'  
%     'stdrtC'  
    'rtcorrC'  
%     'iscgammaA'
    'iscgammaC'
%     'aucA'    
    'aucC'    
    'aucresidC'};
    
plotTW = {
    'rtweightA'
    'gammaA'   
    'aucA'     
    'aucresidC'};

plotST = {
    'rtweightA'
    'gammaA'   
%     'gammaC'   
%     'aucA'     
    'aucC'     };

colortmp = jet;
% colorchoice = colortmp(linspace(4,60,8), :);
bluechoice = colortmp([4 12 17 22], :);
redchoice = colortmp([10 14 23 28]+32, :);
colorchoice = [bluechoice; redchoice];
taskcolor = colorchoice;
linestyle = [0 0 0 0 1 1 1 1];
figure;
for ii = 1:length(plotRDM)
    thispower = powerrdm.(plotRDM{ii});
    if linestyle(ii)
        plot(thispower, 'LineStyle', '-', 'Color', taskcolor(ii, :), 'LineWidth',1.5)
    else
        plot(thispower, 'LineStyle', '-.', 'Color', taskcolor(ii, :), 'LineWidth',1.5)
    end
    hold on
    plot([100,100], [0,1], 'Color', [0.75 0.75, 0.75, 0.6])
    plot([1,1000], [0.6,0.6], 'Color', [0.75 0.75, 0.75, 0.6])
    hold on
end
box off
ylim([0, 1])
set(gca, 'YTick', 0:0.2:1, 'XTick', 0:200:1e3, 'LineWidth', 1)
set(gca, 'YTickLabel', {}, 'XTicklabel', {})
% plot()

taskcolor = colorchoice(5:end, :);
linestyle = [0 0 0 1];
figure;
for ii = 1:length(plotTW)
    thispower = powertw.(plotTW{ii});
    if linestyle(ii)
        plot(thispower, 'LineStyle', '-', 'Color', taskcolor(ii, :), 'LineWidth',1.5)
    else
        plot(thispower, 'LineStyle', '-.', 'Color', taskcolor(ii, :), 'LineWidth',1.5)
    end
    hold on
    plot([100,100], [0,1], 'Color', [0.75 0.75, 0.75, 0.6])
    plot([1,1000], [0.6,0.6], 'Color', [0.75 0.75, 0.75, 0.6])
    hold on
end
box off
ylim([0, 1])
set(gca, 'YTick', 0:0.2:1, 'XTick', 0:200:1e3, 'LineWidth', 1)
set(gca, 'YTickLabel', {}, 'XTicklabel', {})

taskcolor = colorchoice(5:end, :);
linestyle = [0 0 1];
figure;
for ii = 1:length(plotST)
    thispower = powerst.(plotST{ii});
    if linestyle(ii)
        plot(thispower, 'LineStyle', '-', 'Color', taskcolor(ii, :), 'LineWidth',1.5)
    else
        plot(thispower, 'LineStyle', '-.', 'Color', taskcolor(ii, :), 'LineWidth',1.5)
    end
    hold on
    plot([100,100], [0,1], 'Color', [0.75 0.75, 0.75, 0.6])
    plot([1,1000], [0.6,0.6], 'Color', [0.75 0.75, 0.75, 0.6])
    hold on
end
box off
ylim([0, 1])
set(gca, 'YTick', 0:0.2:1, 'XTick', 0:200:1e3, 'LineWidth', 1)
set(gca, 'YTickLabel', {}, 'XTicklabel', {})
