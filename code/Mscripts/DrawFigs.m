%%
clear;home;
tblrdmin1 = readtable('result_files\RDMin1session1113-15;44;34.csv');

%%
tblrdmin1mz = tblrdmin1(tblrdmin1.zyg==1, :);
tblrdmin1dz = tblrdmin1(tblrdmin1.zyg==2, :);

eraseMZ = FindStrinCell({'T001','T007','T013','T028','T033','T035','T054','T055','T087','T090'}, ... % max ten pairs of MZ auc difference 'T088',
    tblrdmin1mz.twinsNum);
tblrdmin1mz(eraseMZ,:) = [];

%% PLOT 
diffculty = {[tblrdmin1mz.mcoh1; tblrdmin1mz.mcoh2], [tblrdmin1dz.mcoh1; tblrdmin1dz.mcoh2]};
rtime = {[tblrdmin1mz.mrtime1; tblrdmin1mz.mrtime2], [tblrdmin1dz.mrtime1; tblrdmin1dz.mrtime2]};
accuracy = {[tblrdmin1mz.accu1; tblrdmin1mz.accu2], [tblrdmin1dz.accu1; tblrdmin1dz.accu2]};
mconf = {[tblrdmin1mz.mconf1; tblrdmin1mz.mconf2], [tblrdmin1dz.mconf1; tblrdmin1dz.mconf2]};
auc = {[tblrdmin1mz.auc1; tblrdmin1mz.auc2], [tblrdmin1dz.auc1; tblrdmin1dz.auc2]};
stdrtime = {[tblrdmin1mz.stdrtime1; tblrdmin1mz.stdrtime2], [tblrdmin1dz.stdrtime1; tblrdmin1dz.stdrtime2]};
rtcorr = {[tblrdmin1mz.rtcorr1; tblrdmin1mz.rtcorr2], [tblrdmin1dz.rtcorr1; tblrdmin1dz.rtcorr2]};
iscgamma = {[tblrdmin1mz.iscgamma1; tblrdmin1mz.iscgamma2], [tblrdmin1dz.iscgamma1; tblrdmin1dz.iscgamma2]};

%%
%%%%%%%%%%%%%
btmp = diffculty;
meanforplot = cellfun(@mean, btmp);
semforplot = cellfun(@std, btmp)./(cellfun(@length, btmp).^0.5);
% mean_roi(ii,:) = meanforplot;
% sem_roi(ii,:) = semforplot;

figure;
taskcolors = lines(length(meanforplot));

b = bar([1,2], meanforplot,'LineWidth', 1.4, 'BarWidth', 0.4);
b.FaceColor = 'flat';
b.CData = taskcolors;
b.BaseLine.LineWidth = 1.4;
hold on
eb = errorbar([1,2], meanforplot, semforplot, '.',...
    'LineWidth',1.5,'MarkerFaceColor','white','MarkerEdgeColor','black', 'CapSize',1.3, 'Color','black');
box off
ylim([0,15])
set(gca, 'YTick', 0:5:15, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

%%%%%%%%%%%%%%%%%%%%%%
btmp = rtime;
meanforplot = cellfun(@mean, btmp);
semforplot = cellfun(@std, btmp)./(cellfun(@length, btmp).^0.5);
% mean_roi(ii,:) = meanforplot;
% sem_roi(ii,:) = semforplot;

figure;
taskcolors = lines(length(meanforplot));

b = bar([1,2], meanforplot,'LineWidth', 1.4, 'BarWidth', 0.4);
b.FaceColor = 'flat';
b.CData = taskcolors;
b.BaseLine.LineWidth = 1.4;
hold on
eb = errorbar([1,2], meanforplot, semforplot, '.',...
    'LineWidth',1.5,'MarkerFaceColor','white','MarkerEdgeColor','black', 'CapSize',1.4, 'Color','black');
box off
ylim([0,2])
set(gca, 'YTick', 0:0.5:2, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

%%%%%%%%%%%%%%%%%%%%%%
btmp = accuracy;
meanforplot = cellfun(@mean, btmp);
semforplot = cellfun(@std, btmp)./(cellfun(@length, btmp).^0.5);
% mean_roi(ii,:) = meanforplot;
% sem_roi(ii,:) = semforplot;

figure;
taskcolors = lines(length(meanforplot));

b = bar([1,2], meanforplot,'LineWidth', 1.4, 'BarWidth', 0.4);
b.FaceColor = 'flat';
b.CData = taskcolors;
b.BaseLine.LineWidth = 1.4;
hold on
eb = errorbar([1,2], meanforplot, semforplot, '.',...
    'LineWidth',1.5,'MarkerFaceColor','white','MarkerEdgeColor','black', 'CapSize',1.4, 'Color','black');
box off
ylim([0,0.6])
set(gca, 'YTick', 0:0.2:0.6, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})


%%%%%%%%%%%%%%%%%%%%%%
btmp = auc;
meanforplot = cellfun(@mean, btmp);
semforplot = cellfun(@std, btmp)./(cellfun(@length, btmp).^0.5);
% mean_roi(ii,:) = meanforplot;
% sem_roi(ii,:) = semforplot;

figure;
taskcolors = lines(length(meanforplot));

b = bar([1,2], meanforplot,'LineWidth', 1.4, 'BarWidth', 0.4);
b.FaceColor = 'flat';
b.CData = taskcolors;
b.BaseLine.LineWidth = 1.4;
hold on
eb = errorbar([1,2], meanforplot, semforplot, '.',...
    'LineWidth',1.5,'MarkerFaceColor','white','MarkerEdgeColor','black', 'CapSize',1.3, 'Color','black');
box off
ylim([0, 1])
set(gca, 'YTick', 0:0.25:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

%%%%%%%%%%%%%%%%%%%%%%
btmp = mconf;
meanforplot = cellfun(@mean, btmp);
semforplot = cellfun(@std, btmp)./(cellfun(@length, btmp).^0.5);
% mean_roi(ii,:) = meanforplot;
% sem_roi(ii,:) = semforplot;

figure;
taskcolors = lines(length(meanforplot));

b = bar([1,2], meanforplot,'LineWidth', 1.4, 'BarWidth', 0.4);
b.FaceColor = 'flat';
b.CData = taskcolors;
b.BaseLine.LineWidth = 1.4;
hold on
eb = errorbar([1,2], meanforplot, semforplot, '.',...
    'LineWidth',1.5,'MarkerFaceColor','white','MarkerEdgeColor','black', 'CapSize',1.3, 'Color','black');
box off
ylim([0, 6])
set(gca, 'YTick', 0:2:6, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

%%%%%%%%%%%%%%%%%%%%%%
btmp = stdrtime;
meanforplot = cellfun(@mean, btmp);
semforplot = cellfun(@std, btmp)./(cellfun(@length, btmp).^0.5);
% mean_roi(ii,:) = meanforplot;
% sem_roi(ii,:) = semforplot;

figure;
taskcolors = lines(length(meanforplot));

b = bar([1,2], meanforplot,'LineWidth', 1.4, 'BarWidth', 0.4);
b.FaceColor = 'flat';
b.CData = taskcolors;
b.BaseLine.LineWidth = 1.4;
hold on
eb = errorbar([1,2], meanforplot, semforplot, '.',...
    'LineWidth',1.5,'MarkerFaceColor','white','MarkerEdgeColor','black', 'CapSize',1.3, 'Color','black');
box off
ylim([0, 0.5])
set(gca, 'YTick', 0:0.1:0.5, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

%%%%%%%%%%%%%%%%%%%%%%
btmp = rtcorr;
meanforplot = cellfun(@mean, btmp);
semforplot = cellfun(@std, btmp)./(cellfun(@length, btmp).^0.5);
% mean_roi(ii,:) = meanforplot;
% sem_roi(ii,:) = semforplot;

figure;
taskcolors = lines(length(meanforplot));

b = bar([1,2], meanforplot,'LineWidth', 1.4, 'BarWidth', 0.4);
b.FaceColor = 'flat';
b.CData = taskcolors;
b.BaseLine.LineWidth = 1.3;
hold on
eb = errorbar([1,2], meanforplot, semforplot, '.',...
    'LineWidth',1.5,'MarkerFaceColor','white','MarkerEdgeColor','black', 'CapSize',1.4, 'Color','black');
box off
ylim([-0.5, 0])
set(gca, 'YTick', -0.5:0.1:0, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

%%%%%%%%%%%%%%%%%%%%%%
btmp = iscgamma;
meanforplot = cellfun(@mean, btmp);
semforplot = cellfun(@std, btmp)./(cellfun(@length, btmp).^0.5);
% mean_roi(ii,:) = meanforplot;
% sem_roi(ii,:) = semforplot;

figure;
taskcolors = lines(length(meanforplot));

b = bar([1,2], meanforplot,'LineWidth', 1.4, 'BarWidth', 0.4);
b.FaceColor = 'flat';
b.CData = taskcolors;
b.BaseLine.LineWidth = 1.3;
hold on
eb = errorbar([1,2], meanforplot, semforplot, '.',...
    'LineWidth',1.5,'MarkerFaceColor','white','MarkerEdgeColor','black', 'CapSize',1.4, 'Color','black');
box off
ylim([0, 1])
set(gca, 'YTick', -0.5:0.1:0, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

%% violin plot

figure;
violin(diffculty,'facecolor',lines(2), 'edgecolor','none', 'facealpha', 1, 'bw',1, 'mc','k-', 'medc', '')  % 'bw',[],...
legend off
box off
ylim([0,20])
set(gca, 'XTick',0:3, 'YTick', 0:5:20, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

figure;
violin(accuracy,'facecolor',lines(2), 'edgecolor','none', 'facealpha', 1,  'mc','k-', 'medc', '')  % 'bw',[],...
legend off
box off
ylim([0,1])
set(gca,'XTick',0:3, 'YTick', 0:0.2:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

figure;
violin(rtime,'facecolor',lines(2), 'edgecolor','none', 'facealpha', 1, 'mc','k-', 'medc', '')  % 'bw',[],...
legend off
box off
ylim([0,3]);xlim([0.5, 2.5])
set(gca,'XTick',0:3, 'YTick', 0:3, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

figure;
violin(stdrtime,'facecolor',lines(2), 'edgecolor','none', 'facealpha', 1, 'mc','k-', 'medc', '')  % 'bw',[],...
legend off
box off
ylim([0,1]);xlim([0.5, 2.5])
set(gca,'XTick',0:3, 'YTick', 0:0.2:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

figure;
violin(mconf,'facecolor',lines(2), 'edgecolor','none', 'facealpha', 1, 'mc','k-', 'medc', '')  % 'bw',[],...
legend off
box off
ylim([0,8]);xlim([0.5, 2.5])
set(gca,'XTick',0:3, 'YTick', 0:2:8, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

figure;
violin(auc,'facecolor',lines(2), 'edgecolor','none', 'facealpha', 1, 'mc','k-', 'medc', '')  % 'bw',[],...
legend off
box off
ylim([0,1]);xlim([0.5, 2.5])
set(gca,'XTick',0:3, 'YTick', 0:0.25:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

figure;
violin(rtcorr,'facecolor',lines(2), 'edgecolor','none', 'facealpha', 1, 'mc','k-', 'medc', '')  % 'bw',[],...
legend off
box off
ylim([-1,0.5]); xlim([0.5, 2.5])
set(gca,'XTick',0:3, 'YTick', -1:0.25:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

figure;
violin(iscgamma,'facecolor',lines(2), 'edgecolor','none', 'facealpha', 1, 'mc','k-', 'medc', '')  % 'bw',[],...
legend off
box off
ylim([-0.5,1.5]);xlim([0.5, 2.5])
set(gca,'XTick',0:3, 'YTick', -1:0.5:1.5, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

%% data from Analy_ICC
mztmp = corr_self_aucmz;
dztmp = corr_self_aucdz;
figure; 
facecolor = lines(2);
% tmprange = [ceil(max(mztmp)*10)/10-0.4,  ceil(max(mztmp)*10)/10];
histogram(mztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(1,:))
hold on 
histogram(dztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(2,:))
box off
aaa = round(get(gca,'XTick'),1);
aaa = [aaa(end)-0.4, aaa(end)];
xlim(aaa); ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', aaa(1):0.1:aaa(2), 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

mztmp = corr_self_accumz;
dztmp = corr_self_accudz;
figure; 
facecolor = lines(2);
% tmprange = [ceil(max(mztmp)*10)/10-0.4,  ceil(max(mztmp)*10)/10];
histogram(mztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(1,:))
hold on 
histogram(dztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(2,:))
box off
aaa = round(get(gca,'XTick'),1);
aaa = [aaa(end)-0.4, aaa(end)];
xlim(aaa); ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', aaa(1):0.1:aaa(2), 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

mztmp = corr_self_mrtimemz;
dztmp = corr_self_mrtimedz;
figure; 
facecolor = lines(2);
% tmprange = [ceil(max(mztmp)*10)/10-0.4,  ceil(max(mztmp)*10)/10];
histogram(mztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(1,:))
hold on 
histogram(dztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(2,:))
box off
% aaa = round(get(gca,'XTick'),1);
aaa = [0.6, 1];
xlim(aaa); ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', aaa(1):0.1:aaa(2), 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

mztmp = corr_self_stdrtimemz;
dztmp = corr_self_stdrtimedz;
figure; 
facecolor = lines(2);
% tmprange = [ceil(max(mztmp)*10)/10-0.4,  ceil(max(mztmp)*10)/10];
histogram(mztmp,110, 'EdgeColor','none', 'FaceColor',facecolor(1,:))
hold on 
histogram(dztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(2,:))
box off
aaa = round(get(gca,'XTick'),1);
aaa = [aaa(end)-0.4, aaa(end)];
xlim(aaa); ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', aaa(1):0.1:aaa(2), 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

mztmp = corr_self_mconfmz;
dztmp = corr_self_mconfdz;
figure; 
facecolor = lines(2);
% tmprange = [ceil(max(mztmp)*10)/10-0.4,  ceil(max(mztmp)*10)/10];
histogram(mztmp,90, 'EdgeColor','none', 'FaceColor',facecolor(1,:))
hold on 
histogram(dztmp,90, 'EdgeColor','none', 'FaceColor',facecolor(2,:))
box off
aaa = round(get(gca,'XTick'),1);
aaa = [aaa(end)-0.4, aaa(end)];
xlim(aaa); ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', aaa(1):0.1:aaa(2), 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

mztmp = corr_self_myrtcorrmz;
dztmp = corr_self_myrtcorrdz;
figure; 
facecolor = lines(2);
% tmprange = [ceil(max(mztmp)*10)/10-0.4,  ceil(max(mztmp)*10)/10];
histogram(mztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(1,:))
hold on 
histogram(dztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(2,:))
box off
aaa = round(get(gca,'XTick'),1);
aaa = [aaa(end)-0.4, aaa(end)];
xlim(aaa); ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', aaa(1):0.1:aaa(2), 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})


mztmp = corr_self_myiscgammamz;
dztmp = corr_self_myiscgammadz;
figure; 
facecolor = lines(2);
% tmprange = [ceil(max(mztmp)*10)/10-0.4,  ceil(max(mztmp)*10)/10];
histogram(mztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(1,:))
hold on 
histogram(dztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(2,:))
box off
aaa = round(get(gca,'XTick'),1);
aaa = [aaa(end)-0.4, aaa(end)]-0.1;
xlim(aaa); ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', aaa(1):0.1:aaa(2), 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

%%
colormds = [lines(2); 0.5,0.5,0.5];
dist1 = icc_mztwins_auc;
dist2 = icc_dztwins_auc;
dist3 = icc_mzstranger_auc;
dist4 = icc_dzstranger_auc;
PlotTwinsICCdist(dist1, dist2, dist3, dist4, colormds)

dist1 = icc_mztwins_aucresid;
dist2 = icc_dztwins_aucresid;
dist3 = icc_mzstranger_aucresid;
dist4 = icc_dzstranger_aucresid;
PlotTwinsICCdist(dist1, dist2, dist3, dist4, colormds)

dist1 = icc_mztwins_accu;
dist2 = icc_dztwins_accu;
dist3 = icc_mzstranger_accu;
dist4 = icc_dzstranger_accu;
PlotTwinsICCdist(dist1, dist2, dist3, dist4, colormds)

dist1 = icc_mztwins_mcoh;
dist2 = icc_dztwins_mcoh;
dist3 = icc_mzstranger_mcoh;
dist4 = icc_dzstranger_mcoh;
PlotTwinsICCdist(dist1, dist2, dist3, dist4, colormds)

dist1 = icc_mztwins_mconf;
dist2 = icc_dztwins_mconf;
dist3 = icc_mzstranger_mconf;
dist4 = icc_dzstranger_mconf;
PlotTwinsICCdist(dist1, dist2, dist3, dist4, colormds)

dist1 = icc_mztwins_mrtime;
dist2 = icc_dztwins_mrtime;
dist3 = icc_mzstranger_mrtime;
dist4 = icc_dzstranger_mrtime;
PlotTwinsICCdist(dist1, dist2, dist3, dist4, colormds)

dist1 = icc_mztwins_stdrtime;
dist2 = icc_dztwins_stdrtime;
dist3 = icc_mzstranger_stdrtime;
dist4 = icc_dzstranger_stdrtime;
PlotTwinsICCdist(dist1, dist2, dist3, dist4, colormds)

dist1 = icc_mztwins_myrtcorrclear;
dist2 = icc_dztwins_myrtcorrclear;
dist3 = icc_mzstranger_myrtcorrclear;
dist4 = icc_dzstranger_myrtcorrclear;
PlotTwinsICCdist(dist1, dist2, dist3, dist4, colormds)

dist1 = icc_mztwins_myiscgamma;
dist2 = icc_dztwins_myiscgamma;
dist3 = icc_mzstranger_myiscgamma;
dist4 = icc_dzstranger_myiscgamma;
PlotTwinsICCdist(dist1, dist2, dist3, dist4, colormds)

%% data from MentalizationAnalyses.m
btmp = {tbltwinsmz.confcorrraw, tblstrangersmz.confcorrraw, tbltwinsdz.confcorrraw, tblstrangersdz.confcorrraw};
meanforplot = cellfun(@mean, btmp);
semforplot = cellfun(@std, btmp)./(cellfun(@length, btmp).^0.5);

figure;
taskcolors = [lines(2); lines(2)*1.7];
b = bar([1,2,3,4], meanforplot,'LineWidth', 1.4, 'BarWidth', 0.4);
b.FaceColor = 'flat';
b.CData = taskcolors;
b.BaseLine.LineWidth = 1.4;
hold on
eb = errorbar([1,2,3,4], meanforplot, semforplot, '.',...
    'LineWidth',1.5,'MarkerFaceColor','white','MarkerEdgeColor','black', 'CapSize',1.3, 'Color','black');
box off
ylim([0, 0.4])
set(gca, 'YTick', 0:0.1:0.5, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})


%%%%%%%%%%%%%
btmp = {tbltwinsmz.confcorr_residhigh, tblstrangersmz.confcorr_residhigh, tbltwinsdz.confcorr_residhigh, tblstrangersdz.confcorr_residhigh};
meanforplot = cellfun(@mean, btmp);
semforplot = cellfun(@std, btmp)./(cellfun(@length, btmp).^0.5);

figure;
taskcolors = [lines(2); lines(2)*1.7];
b = bar([1,2,3,4], meanforplot,'LineWidth', 1.4, 'BarWidth', 0.4);
b.FaceColor = 'flat';
b.CData = taskcolors;
b.BaseLine.LineWidth = 1.4;
hold on
eb = errorbar([1,2,3,4], meanforplot, semforplot, '.',...
    'LineWidth',1.5,'MarkerFaceColor','white','MarkerEdgeColor','black', 'CapSize',1.3, 'Color','black');
box off
ylim([0, 0.4])
set(gca, 'YTick', 0:0.1:0.5, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

%%%%%%%%%%%%%
btmp = {tbltwinsmz.myauc, tblstrangersmz.myauc, tbltwinsdz.myauc, tblstrangersdz.myauc};
meanforplot = cellfun(@mean, btmp);
semforplot = cellfun(@std, btmp)./(cellfun(@length, btmp).^0.5);

figure;
taskcolors = [lines(2); lines(2)*1.7];
b = bar([1,2,3,4], meanforplot,'LineWidth', 1.4, 'BarWidth', 0.4);
b.FaceColor = 'flat';
b.CData = taskcolors;
b.BaseLine.LineWidth = 1.4;
hold on
eb = errorbar([1,2,3,4], meanforplot, semforplot, '.',...
    'LineWidth',1.5,'MarkerFaceColor','white','MarkerEdgeColor','black', 'CapSize',1.3, 'Color','black');
box off
ylim([0.4, 0.8])
hold on 
plot([0,5],[0.5,0.5],'k--')
set(gca, 'YTick', 0.1:0.1:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})


%%%%%%%%%%%%%
btmp = {tbltwinsmz.myaucresidhigh, tblstrangersmz.myaucresidhigh, tbltwinsdz.myaucresidhigh, tblstrangersdz.myaucresidhigh};
meanforplot = cellfun(@mean, btmp);
semforplot = cellfun(@std, btmp)./(cellfun(@length, btmp).^0.5);

figure;
taskcolors = [lines(2); lines(2)*1.7];
b = bar([1,2,3,4], meanforplot,'LineWidth', 1.4, 'BarWidth', 0.4);
b.FaceColor = 'flat';
b.CData = taskcolors;
b.BaseLine.LineWidth = 1.4;
hold on
eb = errorbar([1,2,3,4], meanforplot, semforplot, '.',...
    'LineWidth',1.5,'MarkerFaceColor','white','MarkerEdgeColor','black', 'CapSize',1.3, 'Color','black');
box off
ylim([0.4, 0.8])
hold on 
plot([0,5],[0.5,0.5],'k--')
set(gca, 'YTick', 0.1:0.1:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})


%%%%%%%%%%%%%
btmp = {tbltwinsmz.myfitauc, tblstrangersmz.myfitauc, tbltwinsdz.myfitauc, tblstrangersdz.myfitauc};
meanforplot = cellfun(@mean, btmp);
semforplot = cellfun(@std, btmp)./(cellfun(@length, btmp).^0.5);

figure;
taskcolors = [lines(2), lines(2)*1.7]';
taskcolors =  min(taskcolors,1);
taskcolors =  reshape(taskcolors,3,4)';
b = bar([1,2,3,4], meanforplot,'LineWidth', 1.4, 'BarWidth', 0.4);
b.FaceColor = 'flat';
b.CData = taskcolors;
b.BaseLine.LineWidth = 1.4;
hold on
eb = errorbar([1,2,3,4], meanforplot, semforplot, '.',...
    'LineWidth',1.5,'MarkerFaceColor','white','MarkerEdgeColor','black', 'CapSize',1.3, 'Color','black');
box off
ylim([0.4, 0.8])
hold on 
plot([0,5],[0.5,0.5],'k--')
set(gca, 'YTick', 0.1:0.1:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

%%
btmp = {tbltwinsmz.confcorrraw, tblstrangersmz.confcorrraw, tbltwinsdz.confcorrraw, tblstrangersdz.confcorrraw};
taskcolors = [lines(2), lines(2)*1.7]';
taskcolors =  min(taskcolors,1);
taskcolors =  reshape(taskcolors,3,4)';
figure;
violin(btmp,'facecolor',taskcolors, 'edgecolor','none', 'facealpha', 1, 'mc','k-', 'medc', '')  % 'bw',[],...
legend off
box off
hold on 
plot([0,5],[0,0],'k--')
ylim([-0.5,1]); xlim([0.5, 4.5])
set(gca,'XTick',0:5, 'YTick', -0.5:0.5:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

btmp = {tbltwinsmz.confcorr_residhigh, tblstrangersmz.confcorr_residhigh, tbltwinsdz.confcorr_residhigh, tblstrangersdz.confcorr_residhigh};
taskcolors = [lines(2), lines(2)*1.7]';
taskcolors =  min(taskcolors,1);
taskcolors =  reshape(taskcolors,3,4)';
figure;
violin(btmp,'facecolor',taskcolors, 'edgecolor','none', 'facealpha', 1, 'mc','k-', 'medc', '')  % 'bw',[],...
legend off
box off
hold on 
plot([0,5],[0,0],'k--')
ylim([-0.5,1]); xlim([0.5, 4.5])
set(gca,'XTick',0:5, 'YTick', -0.5:0.5:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

btmp = {tbltwinsmz.myauc, tblstrangersmz.myauc, tbltwinsdz.myauc, tblstrangersdz.myauc};
taskcolors = [lines(2), lines(2)*1.7]';
taskcolors =  min(taskcolors,1);
taskcolors =  reshape(taskcolors,3,4)';
figure;
violin(btmp,'facecolor',taskcolors, 'edgecolor','none', 'facealpha', 1, 'mc','k-', 'medc', '')  % 'bw',[],...
legend off
box off
hold on 
plot([0,5],[0.5,0.5],'k--')
ylim([0,1]); xlim([0.5, 4.5])
set(gca,'XTick',0:5, 'YTick', -0.5:0.25:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

btmp = {tbltwinsmz.myaucresidhigh, tblstrangersmz.myaucresidhigh, tbltwinsdz.myaucresidhigh, tblstrangersdz.myaucresidhigh};
taskcolors = [lines(2), lines(2)*1.7]';
taskcolors =  min(taskcolors,1);
taskcolors =  reshape(taskcolors,3,4)';
figure;
violin(btmp,'facecolor',taskcolors, 'edgecolor','none', 'facealpha', 1, 'mc','k-', 'medc', '')  % 'bw',[],...
legend off
box off
hold on 
plot([0,5],[0.5,0.5],'k--')
ylim([0,1]); xlim([0.5, 4.5])
set(gca,'XTick',0:5, 'YTick', -0.5:0.25:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

btmp = {tbltwinsmz.myiscgamma, tblstrangersmz.myiscgamma, tbltwinsdz.myiscgamma, tblstrangersdz.myiscgamma};
taskcolors = [lines(2), lines(2)*1.7]';
taskcolors =  min(taskcolors,1);
taskcolors =  reshape(taskcolors,3,4)';
figure;
violin(btmp,'facecolor',taskcolors, 'edgecolor','none', 'facealpha', 1, 'mc','k-', 'medc', '')  % 'bw',[],...
legend off
box off
hold on 
plot([0,5],[0,0],'k--')
ylim([-1,1]); xlim([0.5, 4.5])
set(gca,'XTick',0:5, 'YTick', -1:0.5:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

btmp = {tbltwinsmz.myiscgammahigh, tblstrangersmz.myiscgammahigh, tbltwinsdz.myiscgammahigh, tblstrangersdz.myiscgammahigh};
taskcolors = [lines(2), lines(2)*1.7]';
taskcolors =  min(taskcolors,1);
taskcolors =  reshape(taskcolors,3,4)';
figure;
violin(btmp,'facecolor',taskcolors, 'edgecolor','none', 'facealpha', 1, 'mc','k-', 'medc', '')  % 'bw',[],...
legend off
box off
hold on 
plot([0,5],[0,0],'k--')
ylim([-1,1]); xlim([0.5, 4.5])
set(gca,'XTick',0:5, 'YTick', -1:0.5:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

%%
colormds = [lines(2); 0.5,0.5,0.5];
dist1 = icc_mztwins_rtweight;
dist2 = icc_dztwins_rtweight;
dist3 = icc_mzstranger_rtweight;
dist4 = icc_dzstranger_rtweight;
figure;
h = histogram(dist1,130,  'EdgeColor','none', 'FaceColor',colormds(1,:));
hold on; 
h = histogram(dist3,110 ,'EdgeColor','none', 'FaceColor',colormds(3,:));
box off
xlim([-0.4,0.8]);ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', -0.4:0.2:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})
figure;
h = histogram(dist2,110,  'EdgeColor','none', 'FaceColor',colormds(2,:));
hold on; 
h = histogram(dist4,100 ,'EdgeColor','none', 'FaceColor',colormds(3,:));
box off
xlim([-0.4,0.8]);ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', -0.4:0.2:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})
figure;
h = histogram(dist1,130,  'EdgeColor','none', 'FaceColor',colormds(1,:));
hold on; 
h = histogram(dist2,110 ,'EdgeColor','none', 'FaceColor',colormds(2,:));
box off
xlim([-0.4,0.8]);ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', -0.4:0.2:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})


%%%%%%%%%%%%%%%%%%%%
dist1 = icc_mztwins_mentalraw;
dist2 = icc_dztwins_mentalraw;
dist3 = icc_mzstranger_mentalraw;
dist4 = icc_dzstranger_mentalraw;
figure;
h = histogram(dist1,100,  'EdgeColor','none', 'FaceColor',colormds(1,:));
hold on; 
h = histogram(dist3,100 ,'EdgeColor','none', 'FaceColor',colormds(3,:));
box off
xlim([-0.4,0.8]);ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', -0.4:0.2:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})
figure;
h = histogram(dist2,100,  'EdgeColor','none', 'FaceColor',colormds(2,:));
hold on; 
h = histogram(dist4,100 ,'EdgeColor','none', 'FaceColor',colormds(3,:));
box off
xlim([-0.4,0.8]);ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', -0.4:0.2:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})
figure;
h = histogram(dist1,100,  'EdgeColor','none', 'FaceColor',colormds(1,:));
hold on; 
h = histogram(dist2,100 ,'EdgeColor','none', 'FaceColor',colormds(2,:));
box off
xlim([-0.4,0.8]);ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', -0.4:0.2:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})


%%%%%%%%%%%%%%%%%%%%
dist1 = icc_mztwins_mental;
dist2 = icc_dztwins_mental;
dist3 = icc_mzstranger_mental;
dist4 = icc_dzstranger_mental;
figure;
h = histogram(dist1,100,  'EdgeColor','none', 'FaceColor',colormds(1,:));
hold on; 
h = histogram(dist3,100 ,'EdgeColor','none', 'FaceColor',colormds(3,:));
box off
xlim([-0.4,0.8]);ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', -0.4:0.2:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})
figure;
h = histogram(dist2,100,  'EdgeColor','none', 'FaceColor',colormds(2,:));
hold on; 
h = histogram(dist4,100 ,'EdgeColor','none', 'FaceColor',colormds(3,:));
box off
xlim([-0.4,0.8]);ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', -0.4:0.2:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})
figure;
h = histogram(dist1,100,  'EdgeColor','none', 'FaceColor',colormds(1,:));
hold on; 
h = histogram(dist2,100 ,'EdgeColor','none', 'FaceColor',colormds(2,:));
box off
xlim([-0.4,0.8]);ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', -0.4:0.2:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})


%%%%%%%%%%%%%%%%%%%%
dist1 = icc_mztwins_fitauc;
dist2 = icc_dztwins_fitauc;
dist3 = icc_mzstranger_fitauc;
dist4 = icc_dzstranger_fitauc;
figure;
h = histogram(dist1,100,  'EdgeColor','none', 'FaceColor',colormds(1,:));
hold on; 
h = histogram(dist3,110 ,'EdgeColor','none', 'FaceColor',colormds(3,:));
box off
xlim([-0.4,0.8]);ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', -0.4:0.2:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})
figure;
h = histogram(dist2,110,  'EdgeColor','none', 'FaceColor',colormds(2,:));
hold on; 
h = histogram(dist4,100 ,'EdgeColor','none', 'FaceColor',colormds(3,:));
box off
xlim([-0.4,0.8]);ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', -0.4:0.2:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})
figure;
h = histogram(dist1,100,  'EdgeColor','none', 'FaceColor',colormds(1,:));
hold on; 
h = histogram(dist2,110 ,'EdgeColor','none', 'FaceColor',colormds(2,:));
box off
xlim([-0.4,0.8]);ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', -0.4:0.2:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

%%
figure;
% h = heatmap(mzr, 'Colormap',redbluecmap);
h = heatmap(mzr, 'Colormap',jet);
h.ColorLimits = [-1,1];
h.XDisplayLabels= repmat({''},length(mzr),1);
h.YDisplayLabels= repmat({''},length(mzr),1);
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

figure;
h = heatmap(dzr, 'Colormap',jet);
h.ColorLimits = [-1,1];
h.XDisplayLabels= repmat({''},length(dzr),1);
h.YDisplayLabels= repmat({''},length(dzr),1);
set(gca, 'YTickLabel', {}, 'XTickLabel', {})



%% Scatter Plot
txt = sprintf('自评和评价twins时raw AUC的关系');
mzx = mean([tblrdmmz.myauc1,tblrdmmz.myauc2],2);
mzy = tbltwinsmz.myauc;
dzx = mean([tblrdmdz.myauc1,tblrdmdz.myauc2],2);
dzy = tbltwinsdz.myauc;
figure;
PlotScatter2(mzx, mzy, dzx, dzy, txt)
% xlabel('self rdm auc');ylabel('self guess auc');
title('')
set(gca, 'XTick', 0:0.2:1, 'YTick', 0:0.2:1, 'LineWidth',1.4)
xlim([0.2, 1]); ylim([0.2, 1])
set(gca, 'XTickLabel', {}, 'YTickLabel', {})

txt = sprintf('自评和评价twins时resid AUC的关系');
% figure;
% PlotScatterLine(mean([tblrdmmz.myaucresid1,tblrdmmz.myaucresid2],2), tbltwinsmz.myaucresidhigh, txt)
mzx = mean([tblrdmmz.myaucresid1, tblrdmmz.myaucresid1],2);
mzy = tbltwinsmz.myaucresidhigh;
dzx = mean([tblrdmdz.myaucresid1,tblrdmdz.myaucresid1],2);
dzy = tbltwinsdz.myaucresidhigh;
figure;
PlotScatter2(mzx, mzy, dzx, dzy, txt)
% xlabel('self rdm auc');ylabel('self guess auc');
title('')
set(gca, 'XTick', 0:0.2:1, 'YTick', 0:0.2:1, 'LineWidth',1.4)
xlim([0.2, 1]); ylim([0.2, 1])
set(gca, 'XTickLabel', {}, 'YTickLabel', {})


txt = sprintf('自评和评价strangers时 raw AUC的关系');
mzx = mean([tblrdmmz.myauc1,tblrdmmz.myauc2],2);
mzy = tblstrangersmz.myauc;
dzx = mean([tblrdmdz.myauc1,tblrdmdz.myauc2],2);
dzy = tblstrangersdz.myauc;
figure;
PlotScatter2(mzx, mzy, dzx, dzy, txt)
% xlabel('self rdm auc');ylabel('self guess auc');
title('')
set(gca, 'XTick', 0:0.2:1, 'YTick', 0:0.2:1, 'LineWidth',1.4)
xlim([0.2, 1]); ylim([0.2, 1])
set(gca, 'XTickLabel', {}, 'YTickLabel', {})

txt = sprintf('自评和评价strangers时 resid AUC的关系');
mzx = mean([tblrdmmz.myaucresid1, tblrdmmz.myaucresid1],2);
mzy = tblstrangersmz.myaucresidhigh;
dzx = mean([tblrdmdz.myaucresid1, tblrdmdz.myaucresid1],2);
dzy = tblstrangersdz.myaucresidhigh;
figure;
PlotScatter2(mzx, mzy, dzx, dzy, txt)
% xlabel('self rdm auc');ylabel('self guess auc');
title('')
set(gca, 'XTick', 0:0.2:1, 'YTick', 0:0.2:1, 'LineWidth',1.4)
xlim([0.2, 1]); ylim([0.2, 1])
set(gca, 'XTickLabel', {}, 'YTickLabel', {})


%% PLOT Mental BOOSTRAP
taskcolors = [lines(2), lines(2)*1.7]';
taskcolors =  min(taskcolors,1);
taskcolors =  reshape(taskcolors,3,4)';
taskcolors = [taskcolors; 0.5 0.5 0.5];

dist1 = icc_mztwins_rtweight;
dist2 = icc_mzstranger_rtweight ;
dist3 = icc_dztwins_rtweight;
dist4 = icc_dzstranger_rtweight;
dist5 = icc_mztwins_randperm_rtweight;
dist6 = icc_mzstranger_randperm_rtweight ;
dist7 = icc_dztwins_randperm_rtweight;
dist8 = icc_dzstranger_randperm_rtweight;

PlotHist2(dist1, 110, dist5, 110, taskcolors([1,5], :)) %MZ
PlotHist2(dist2, 110, dist6, 110,  taskcolors([2,5], :)) %MZS
PlotHist2(dist3, 110, dist7, 110,  taskcolors([3,5], :)) %DZ
PlotHist2(dist4, 110, dist8, 110,  taskcolors([4,5], :)) %DZS
PlotHist2(dist1, 110, dist3, 110,  taskcolors([1,3], :)) %MZ DZ
PlotHist2(dist2, 110, dist4, 110,  taskcolors([2,4], :)) %MZS DZS

dist1 = icc_mztwins_myiscgamma;
dist2 = icc_mzstranger_myiscgamma ;
dist3 = icc_dztwins_myiscgamma;
dist4 = icc_dzstranger_myiscgamma;
dist5 = icc_mztwins_randperm_myiscgamma;
dist6 = icc_mzstranger_randperm_myiscgamma ;
dist7 = icc_dztwins_randperm_myiscgamma;
dist8 = icc_dzstranger_randperm_myiscgamma;

PlotHist2(dist1, 110, dist5, 110, taskcolors([1,5], :)) %MZ
PlotHist2(dist2, 110, dist6, 110,  taskcolors([2,5], :)) %MZS
PlotHist2(dist3, 110, dist7, 110,  taskcolors([3,5], :)) %DZ
PlotHist2(dist4, 110, dist8, 110,  taskcolors([4,5], :)) %DZS
PlotHist2(dist1, 110, dist3, 110,  taskcolors([1,3], :)) %MZ DZ
PlotHist2(dist2, 110, dist4, 110,  taskcolors([2,4], :)) %MZS DZS

dist1 = icc_mztwins_myiscgammahigh;
dist2 = icc_mzstranger_myiscgammahigh ;
dist3 = icc_dztwins_myiscgammahigh;
dist4 = icc_dzstranger_myiscgammahigh;
dist5 = icc_mztwins_randperm_myiscgammahigh;
dist6 = icc_mzstranger_randperm_myiscgammahigh ;
dist7 = icc_dztwins_randperm_myiscgammahigh;
dist8 = icc_dzstranger_randperm_myiscgammahigh;

PlotHist2(dist1, 110, dist5, 110, taskcolors([1,5], :)) %MZ
PlotHist2(dist2, 110, dist6, 110,  taskcolors([2,5], :)) %MZS
PlotHist2(dist3, 110, dist7, 110,  taskcolors([3,5], :)) %DZ
PlotHist2(dist4, 110, dist8, 110,  taskcolors([4,5], :)) %DZS
PlotHist2(dist1, 110, dist3, 110,  taskcolors([1,3], :)) %MZ DZ
PlotHist2(dist2, 110, dist4, 110,  taskcolors([2,4], :)) %MZS DZS

dist1 = icc_mztwins_mentalraw;
dist2 = icc_mzstranger_mentalraw ;
dist3 = icc_dztwins_mentalraw;
dist4 = icc_dzstranger_mentalraw;
dist5 = icc_mztwins_randperm_mentalraw;
dist6 = icc_mzstranger_randperm_mentalraw ;
dist7 = icc_dztwins_randperm_mentalraw;
dist8 = icc_dzstranger_randperm_mentalraw;

PlotHist2(dist1, 110, dist5, 110, taskcolors([1,5], :)) %MZ
PlotHist2(dist2, 110, dist6, 110,  taskcolors([2,5], :)) %MZS
PlotHist2(dist3, 110, dist7, 110,  taskcolors([3,5], :)) %DZ
PlotHist2(dist4, 110, dist8, 110,  taskcolors([4,5], :)) %DZS
PlotHist2(dist1, 110, dist3, 110,  taskcolors([1,3], :)) %MZ DZ
PlotHist2(dist2, 110, dist4, 110,  taskcolors([2,4], :)) %MZS DZS

dist1 = icc_mztwins_mental;
dist2 = icc_mzstranger_mental ;
dist3 = icc_dztwins_mental;
dist4 = icc_dzstranger_mental;
dist5 = icc_mztwins_randperm_mental;
dist6 = icc_mzstranger_randperm_mental ;
dist7 = icc_dztwins_randperm_mental;
dist8 = icc_dzstranger_randperm_mental;

PlotHist2(dist1, 110, dist5, 110, taskcolors([1,5], :)) %MZ
PlotHist2(dist2, 110, dist6, 110,  taskcolors([2,5], :)) %MZS
PlotHist2(dist3, 110, dist7, 110,  taskcolors([3,5], :)) %DZ
PlotHist2(dist4, 110, dist8, 110,  taskcolors([4,5], :)) %DZS
PlotHist2(dist1, 110, dist3, 110,  taskcolors([1,3], :)) %MZ DZ
PlotHist2(dist2, 110, dist4, 110,  taskcolors([2,4], :)) %MZS DZS

for ii = 1:30
    figure(ii);
    xlim([-0.4,0.8]);ylim([0, 0.04])
    set(gca,'YTick',0:0.01:0.04, 'XTick', -0.4:0.2:1, 'LineWidth', 1.4)
    set(gca, 'XTickLabel', {}, 'YTickLabel', {})
end

%%
% accu mrtime stdrtime mconf auc rt_conf_corr iscgamma
% self_accu_mz = self_accu_mz;
% self_mrtime_mz
% self_stdrtime_mz
% self_mconf_mz
% self_auc_mz
% self_myrtcorr_mz
% self_myiscgamma_mz

mztmp = corr_self_accumz;
dztmp = corr_self_accudz;
figure;
[axtop, axbottom] = PlotQuaHist(mztmp, dztmp, allalphamz(:,1), allalphadz(:,1));
set(axbottom, 'xlim', [0.4, 0.8], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'xlim', [0.5, 0.9], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'XTickLabel', {}, 'YTickLabel', {})
set(axbottom, 'XTickLabel', {}, 'YTickLabel', {})

mztmp = corr_self_mrtimemz;
dztmp = corr_self_mrtimedz;
figure;
[axtop, axbottom] = PlotQuaHist(mztmp, dztmp, allalphamz(:,2), allalphadz(:,2));
set(axbottom, 'xlim', [0.6, 1], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'xlim', [0.6, 1], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'XTickLabel', {}, 'YTickLabel', {})
set(axbottom, 'XTickLabel', {}, 'YTickLabel', {})

mztmp = corr_self_stdrtimemz;
dztmp = corr_self_stdrtimedz;
figure;
[axtop, axbottom] = PlotQuaHist(mztmp, dztmp, allalphamz(:,3), allalphadz(:,3));
set(axbottom, 'xlim', [0.5, 0.9], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'xlim', [0.5, 0.9], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'XTickLabel', {}, 'YTickLabel', {})
set(axbottom, 'XTickLabel', {}, 'YTickLabel', {})

mztmp = corr_self_mconfmz;
dztmp = corr_self_mconfdz;
figure;
[axtop, axbottom] = PlotQuaHist(mztmp, dztmp, allalphamz(:,4), allalphadz(:,4));
set(axbottom, 'xlim', [0.6, 1], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'xlim', [0.6, 1], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'XTickLabel', {}, 'YTickLabel', {})
set(axbottom, 'XTickLabel', {}, 'YTickLabel', {})

mztmp = corr_self_aucmz;
dztmp = corr_self_aucdz;
figure;
[axtop, axbottom] = PlotQuaHist(mztmp, dztmp, allalphamz(:,5), allalphadz(:,5));
set(axbottom, 'xlim', [0.3, 0.7], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'xlim', [0.4, 0.8], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'XTickLabel', {}, 'YTickLabel', {})
set(axbottom, 'XTickLabel', {}, 'YTickLabel', {})

mztmp = corr_self_myrtcorrmz;
dztmp = corr_self_myrtcorrdz;
figure;
[axtop, axbottom] = PlotQuaHist(mztmp, dztmp, allalphamz(:,6), allalphadz(:,6));
set(axbottom, 'xlim', [0.4, 0.8], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'xlim', [0.5, 0.9], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'XTickLabel', {}, 'YTickLabel', {})
set(axbottom, 'XTickLabel', {}, 'YTickLabel', {})

mztmp = corr_self_myiscgammamz;
dztmp = corr_self_myiscgammadz;
figure;
[axtop, axbottom] = PlotQuaHist(mztmp, dztmp, allalphamz(:,7), allalphadz(:,7));
set(axbottom, 'xlim', [0.1, 0.5], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'xlim', [0.3, 0.7], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'XTickLabel', {}, 'YTickLabel', {})
set(axbottom, 'XTickLabel', {}, 'YTickLabel', {})


%%
taskcolors = [lines(2); lines(2)*1.7];
taskcolors =  min(taskcolors,1);
% taskcolors =  reshape(taskcolors,3,4)';
figure;
[axtop, axbottom] = PlotQuaHist(alphatwinsmz_3raw, alphatwinsdz_3raw, alphastrangersmz_3raw, alphastrangersdz_3raw, taskcolors);
set(axbottom, 'xlim', [0.4, 0.8], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'xlim', [0.4, 0.8], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'XTickLabel', {}, 'YTickLabel', {})
set(axbottom, 'XTickLabel', {}, 'YTickLabel', {})

figure;
[axtop, axbottom] = PlotQuaHist(alphatwinsmz_3resid, alphatwinsdz_3resid, alphastrangersmz_3resid, alphastrangersdz_3resid, taskcolors);
set(axbottom, 'xlim', [0.3, 0.7], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'xlim', [0.3, 0.7], 'XTick', 0:0.1:1, 'ylim', [0 0.1], 'YTick', 0:0.02:0.1, 'LineWidth',1.3)
set(axtop, 'XTickLabel', {}, 'YTickLabel', {})
set(axbottom, 'XTickLabel', {}, 'YTickLabel', {})

figure;
PlotHist2(alphatwinsmz_3raw,100, alphatwinsdz_3raw, 100, taskcolors([1,2],:));
hold on
PlotHist2(alphastrangersmz_3raw,100, alphastrangersdz_3raw, 100, taskcolors([3,4],:));
xlim([0.4,0.8]);ylim([0, 0.04])
set(gca,'YTick',0:0.01:0.04, 'XTick', 0:0.1:1, 'LineWidth', 1.4)

figure;
PlotHist2(alphatwinsmz_3resid,100, alphatwinsdz_3resid, 100, taskcolors([1,2],:));
hold on
PlotHist2(alphastrangersmz_3resid,100, alphastrangersdz_3resid, 100, taskcolors([3,4],:));
xlim([0.3,0.7]);ylim([0, 0.04])
set(gca,'YTick',0:0.01:0.04, 'XTick', 0:0.1:1, 'LineWidth', 1.4)


PlotHist2(alphardmmz_3metacog, 110, alphardmdz_3metacog, 110, taskcolors([1,2], :)) 
xlim([0.4,0.8]);ylim([0, 0.04])
set(gca,'YTick',0:0.01:0.04, 'XTick', 0:0.1:1, 'LineWidth', 1.4)
set(gca, 'XTickLabel', {}, 'YTickLabel', {})
