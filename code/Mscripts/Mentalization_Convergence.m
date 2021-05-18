%% For Mentalization Convergence
% load guess data, load rdm data?
clear;home

colorms = [1,0,0; 0.5,0.5,0.5];
colords = [0,1,0; 0.5,0.5,0.5];
colormd = [1,0,0; 0,1,0];

tblguess = readtable('result_files\Guessin1sessions1116-09;24;22.csv');
% tblguess = sortrows(tblguess, 'twinsNum');
tblrdm = readtable('result_files\RDM2sessions1113-15;42;45.csv');
[tbltwins, tblstrangers] = TwinsOrStrangers(tblguess);

eraseMZ = [];
eraseDZ = [];
sameother = [];
%{'T057', 'T020', 'T032', 'T086', 'T114', 'T053', 'T088', 'T112', 'T017','T066'}-----max ten MZ by rtweight
% 'T086','T028','T112','T013','T036','T035','T087','T020','T110','T114'-----max ten MZ by fitauc
% 'T078','T104','T096','T030', 'T044' -----max ten DZ by rtweight
sameother = sortrows(FindStrinCell({'sunfanru','yulikun'}, tblstrangers.othername));
% eraseMZ = FindStrinCell({'T057', 'T020', 'T032', 'T086', 'T114', 'T053', 'T088', 'T112', 'T017','T066'}, tblrdm.twinsNum);
% eraseDZ = FindStrinCell({'T078', 'T104', 'T096', 'T030', 'T044'}, tblrdm.twinsNum);
eraseALL = unique([eraseMZ; eraseDZ; sameother]);
%%% do erase
tblrdm(eraseALL,:) = [];
tbltwins(eraseALL,:) = [];
tblstrangers(eraseALL,:) = [];


tblstrangers.zyg = tblrdm.zyg;
tblstrangers.ismale = tblrdm.ismale;
tblstrangers.age = tblrdm.age;
tbltwins.zyg = tblrdm.zyg;
tbltwins.ismale = tblrdm.ismale;
tbltwins.age = tblrdm.age;

tblrdmmz = tblrdm(tblrdm.zyg==1, :);
tblrdmdz = tblrdm(tblrdm.zyg==2, :);
tbltwinsmz = tbltwins(tbltwins.zyg==1, :);
tbltwinsdz = tbltwins(tbltwins.zyg==2, :);
tblstrangersmz = tblstrangers(tblstrangers.zyg==1, :);
tblstrangersdz = tblstrangers(tblstrangers.zyg==2, :);

%% RTWEIGHT AUC AUCRESID ISGAMMA
mzname = tbltwinsmz.myname;
for ii = 1:height(tbltwinsmz)
    if tbltwinsmz.myname{ii} ~= tblstrangersmz.myname{ii}
        warning('???????????CHECK ORDER!')
          
    end
end
for ii = 1:height(tbltwinsdz)
    if tbltwinsdz.myname{ii} ~= tblstrangersdz.myname{ii}
        warning('???????????CHECK ORDER!')
          
    end
end

mz_rtweight = [tbltwinsmz.rtweight, tblstrangersmz.rtweight];
dz_rtweight = [tbltwinsdz.rtweight, tblstrangersdz.rtweight];
mz_myauc = [tbltwinsmz.myauc, tblstrangersmz.myauc];
dz_myauc = [tbltwinsdz.myauc, tblstrangersdz.myauc];
mz_myaucresid = [tbltwinsmz.myaucresidhigh, tblstrangersmz.myaucresidhigh];
dz_myaucresid = [tbltwinsdz.myaucresidhigh, tblstrangersdz.myaucresidhigh];
mz_myiscgamma = [tbltwinsmz.myiscgamma, tblstrangersmz.myiscgamma];
dz_myiscgamma = [tbltwinsdz.myiscgamma, tblstrangersdz.myiscgamma];
mz_confcorrraw = [tbltwinsmz.confcorrraw, tblstrangersmz.confcorrraw];
dz_confcorrraw = [tbltwinsdz.confcorrraw, tblstrangersdz.confcorrraw];

corr_mentalmz_rtweight = SelfBS(mz_rtweight, 'MZ random rtweight test-retest correlation'); xlim([-0.5,1])
corr_mentaldz_rtweight = SelfBS(dz_rtweight, 'DZ random rtweight test-retest correlation'); xlim([-0.5,1])
corr_mentalmz_myauc = SelfBS(mz_myauc, 'MZ random myauc test-retest correlation'); xlim([-0.5,1])
corr_mentaldz_myauc = SelfBS(dz_myauc, 'DZ random myauc test-retest correlation'); xlim([-0.5,1])
corr_mentalmz_myaucresid = SelfBS(mz_myaucresid, 'MZ random myaucresid test-retest correlation'); xlim([-0.5,1])
corr_mentaldz_myaucresid = SelfBS(dz_myaucresid, 'DZ random myaucresid test-retest correlation'); xlim([-0.5,1])
corr_mentalmz_myiscgamma = SelfBS(mz_myiscgamma, 'MZ random myiscgamma test-retest correlation'); xlim([-0.5,1])
corr_mentaldz_myiscgamma = SelfBS(dz_myiscgamma, 'DZ random myiscgamma test-retest correlation'); xlim([-0.5,1])
corr_mentalmz_confcorrraw = SelfBS(mz_confcorrraw, 'MZ random confcorrraw test-retest correlation'); xlim([-0.5,1])
corr_mentaldz_confcorrraw = SelfBS(dz_confcorrraw, 'DZ random confcorrraw test-retest correlation'); xlim([-0.5,1])


%%
mztmp = corr_mentalmz_rtweight;
dztmp = corr_mentaldz_rtweight;
figure; 
facecolor = lines(2);
% tmprange = [ceil(max(mztmp)*10)/10-0.4,  ceil(max(mztmp)*10)/10];
histogram(mztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(1,:))
hold on 
histogram(dztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(2,:))
box off
aaa = round(get(gca,'XTick'),1);
aaa = [aaa(1), aaa(end)];
xlim(aaa); ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', aaa(1):0.1:aaa(2), 'LineWidth', 1.3)
% set(gca, 'YTickLabel', {}, 'XTickLabel', {})

mztmp = corr_mentalmz_confcorrraw;
dztmp = corr_mentaldz_confcorrraw;
figure; 
facecolor = lines(2);
% tmprange = [ceil(max(mztmp)*10)/10-0.4,  ceil(max(mztmp)*10)/10];
histogram(mztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(1,:))
hold on 
histogram(dztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(2,:))
box off
aaa = round(get(gca,'XTick'),1);
aaa = [aaa(1), aaa(end)];
xlim(aaa); ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', aaa(1):0.1:aaa(2), 'LineWidth', 1.3)

mztmp = corr_mentalmz_myauc;
dztmp = corr_mentaldz_myauc;
figure; 
facecolor = lines(2);
% tmprange = [ceil(max(mztmp)*10)/10-0.4,  ceil(max(mztmp)*10)/10];
histogram(mztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(1,:))
hold on 
histogram(dztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(2,:))
box off
aaa = round(get(gca,'XTick'),1);
aaa = [aaa(1), aaa(end)];
xlim(aaa); ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', aaa(1):0.1:aaa(2), 'LineWidth', 1.3)

mztmp = corr_mentalmz_myaucresid;
dztmp = corr_mentaldz_myaucresid;
figure; 
facecolor = lines(2);
% tmprange = [ceil(max(mztmp)*10)/10-0.4,  ceil(max(mztmp)*10)/10];
histogram(mztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(1,:))
hold on 
histogram(dztmp,100, 'EdgeColor','none', 'FaceColor',facecolor(2,:))
box off
aaa = round(get(gca,'XTick'),1);
aaa = [aaa(1), aaa(end)];
xlim(aaa); ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', aaa(1):0.1:aaa(2), 'LineWidth', 1.3)

%%
figure;
res = PlotScatter2(mz_rtweight(:,1),mz_rtweight(:,2), dz_rtweight(:,1),dz_rtweight(:,2));
titletxt = 'RT weight';
txt = sprintf('%s\nMZ r=%.2f, p=%.3f  DZ r=%.2f, p=%.3f',titletxt, res.mzr, res.mzp, res.dzr, res.dzp);
title(txt)
% xlim([0,1]); ylim([0,1])

figure;
res = PlotScatter2(mz_confcorrraw(:,1),mz_confcorrraw(:,2), dz_confcorrraw(:,1),dz_confcorrraw(:,2));
titletxt = 'confidence correlation';
txt = sprintf('%s\nMZ r=%.2f, MZp=%.3f  DZ r=%.2f, p=%.3f',titletxt, res.mzr, res.mzp, res.dzr, res.dzp);
title(txt)

figure;
res = PlotScatter2(mz_myauc(:,1),mz_myauc(:,2), dz_myauc(:,1),dz_myauc(:,2));
titletxt = 'AUC raw';
txt = sprintf('%s\nMZ r=%.2f, p=%.3f  DZ r=%.2f, DZp=%.3f',titletxt, res.mzr, res.mzp, res.dzr, res.dzp);
title(txt)
xlim([0.2,0.8]); ylim([0.2,0.8])

figure;
res = PlotScatter2(mz_myaucresid(:,1),mz_myaucresid(:,2), dz_myaucresid(:,1),dz_myaucresid(:,2));
titletxt = 'AUC resid';
txt = sprintf('%s\nMZ r=%.2f, p=%.3f  DZ r=%.2f, p=%.3f',titletxt, res.mzr, res.mzp, res.dzr, res.dzp);
title(txt)
xlim([0.2,0.8]); ylim([0.2,0.8])


%%
btmp = {mean(mz_rtweight,2), mean(dz_rtweight,2), mean(mz_confcorrraw,2), mean(dz_confcorrraw,2), mean(mz_myauc,2), mean(dz_myauc,2), mean(mz_myaucresid,2), mean(dz_myaucresid,2)};
meanforplot = cellfun(@mean, btmp);
semforplot = cellfun(@std, btmp)./(cellfun(@length, btmp).^0.5);

figure;
taskcolors = [lines(2); lines(2);lines(2);lines(2)];
b = bar([1 2 3 4 5 6 7 8], meanforplot,'LineWidth', 1.4, 'BarWidth', 0.4);
b.FaceColor = 'flat';
b.CData = taskcolors;
b.BaseLine.LineWidth = 1.4;
hold on
eb = errorbar([1,2,3,4 5 6 7 8], meanforplot, semforplot, '.',...
    'LineWidth',1.5,'MarkerFaceColor','white','MarkerEdgeColor','black', 'CapSize',1.3, 'Color','black');
box off
ylim([-1, 1])
set(gca, 'YTick', -1:0.2:1, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})

%%
mean(mz_rtweight,2), mean(dz_rtweight,2);
mean(mz_confcorrraw,2), mean(dz_confcorrraw,2);
mean(mz_myauc,2), mean(dz_myauc,2);
mean(mz_myaucresid,2), mean(dz_myaucresid,2);







