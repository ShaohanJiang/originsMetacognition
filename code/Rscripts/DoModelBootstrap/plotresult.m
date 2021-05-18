%%
allresfiles = dir('R2MATLAB');
thisfilename = 'allbest_myiscgammahigh.csv';
tbl = readtable(fullfile('R2MATLAB', thisfilename));
Mname = {'ACE', 'ACE-AE', 'ACE-CE', 'E', 'ADE', 'ADE-AE', 'ADE-DE', 'E'};
mcodetmp = unique(tbl.Mcode);
mdlpct = [];
mdlpct(:,1) = mcodetmp';
for ii = 1:length(mcodetmp)
    modlidx = tbl.Mcode == mcodetmp(ii);
    mdlpct(ii,2) = mean(modlidx)*100;
end

mostidx = mdlpct(:,2)==max(mdlpct(:,2));
mostcode = tbl.Mcode == mdlpct(mostidx, 1);
txt = sprintf('%s, %s:%.1f%%', thisfilename(9:end-4), Mname{mdlpct(mostidx, 1)}, max(mdlpct(:,2)));

if mod(mdlpct(mostidx, 1),4) == 2
    figure;histogram(tbl.SA(mostcode), 'EdgeColor','none')
    hold on, histogram(tbl.SE(mostcode), 'EdgeColor','none')
    title(txt)
elseif mod(mdlpct(mostidx, 1),4) == 3
    figure;histogram(tbl.SD_SC(mostcode), 'EdgeColor','none')
    hold on, histogram(tbl.SE(mostcode), 'EdgeColor','none')
    title(txt)
elseif mod(mdlpct(mostidx, 1),4) == 1
    figure;histogram(tbl.SA(mostcode), 'EdgeColor','none')
    hold on;histogram(tbl.SD_SC(mostcode), 'EdgeColor','none')
    hold on; histogram(tbl.SE(mostcode), 'EdgeColor','none')
    title(txt)
end

%%
allresfiles = dir('R2MATLAB');
thisfilename = 'allbest_selfguessaucresid.csv';
tbl = readtable(fullfile('R2MATLAB', thisfilename));
Mname = {'ACE', 'ACE-AE', 'ACE-CE', 'E', 'ADE', 'ADE-AE', 'ADE-DE', 'E'}; 
Mnamemerg = {'AE', 'DE', 'CE', 'E'}; % AE-11, DE-12, CE-13, E-14
tbl.Mcodemerg = tbl.Mcode;
tbl.Mcodemerg(tbl.Mcode==2 | tbl.Mcode==6) = 11;
tbl.Mcodemerg(tbl.Mcode==7) = 12;
tbl.Mcodemerg(tbl.Mcode==3) = 13;
tbl.Mcodemerg(tbl.Mcode==4 | tbl.Mcode==8) = 14;
mcodetmp = unique(tbl.Mcodemerg);
mdlpct = [];
mdlpct(:,1) = mcodetmp';
for ii = 1:length(mcodetmp)
    modlidx = tbl.Mcodemerg == mcodetmp(ii);
    mdlpct(ii,2) = mean(modlidx)*100;
end

mostidx = mdlpct(:,2)==max(mdlpct(:,2));
mostcode = tbl.Mcodemerg == mdlpct(mostidx, 1);
% txt = sprintf('%s, %s:%.1f%%', thisfilename(9:end-4), Mnamemerg{mdlpct(mostidx, 1)-10}, max(mdlpct(:,2)));


stackcolor = [203,24,29; 
    251,106,74; 
    252,174,145; 
    254,229,217;]/255;
figure; 
for ii = 1:length(mdlpct(:,2))
    b = bar(sum(mdlpct(ii:end, 2)/100), 'FaceColor', stackcolor(ii,:));
    b.LineWidth = 1.3;
    b.BarWidth = 0.6;
    hold on
end
ylim([0, 1])
box off
set(gca, 'YTick',0:0.2:1, 'LineWidth',1.4)
set(gca, 'YTickLabel',{}, 'XTickLabel',{})


if mdlpct(mostidx, 1) == 11
    y = tbl.SA(mostcode);
    thisfacecolor = stackcolor(1,:);   
elseif mdlpct(mostidx, 1) == 12 
    y = tbl.SD_SC(mostcode);
    thisfacecolor = stackcolor(2,:);
elseif mdlpct(mostidx, 1) == 13
    y = tbl.SD_SC(mostcode);
    thisfacecolor =  stackcolor(3,:);

end

% npara = length(y);
figure; histogram(y, 50, 'EdgeColor','none', 'Normalization','probability', 'FaceColor', thisfacecolor, 'FaceAlpha', 1)
box off
ylim([0, 0.08])
xlim([0.1, 0.5])
set(gca, 'XTick', 0.1:0.1:0.9, 'YTick', 0:0.02:0.08, 'LineWidth', 1.4)
set(gca, 'YTickLabel',{}, 'XTickLabel',{})


%% NEWEST VERSION
allresfiles = dir('R2MATLAB');
thisfilename = 'allbest_twin_myiscgammahigh.csv';
tbl = readtable(fullfile('R2MATLAB', thisfilename));
Mname = {'ACE', 'ACE-AE', 'ACE-CE', 'E', 'ADE', 'ADE-AE', 'ADE-DE', 'E'}; 
Mnamemerg = {'AE-DE', 'CE', 'E'}; % AE-DE-21, CE-22, E-23
tbl.Mcodemerg = tbl.Mcode;
tbl.Mcodemerg(tbl.Mcode==2 | tbl.Mcode==6 |tbl.Mcode==7) = 21;
tbl.Mcodemerg(tbl.Mcode==3) = 22;
tbl.Mcodemerg(tbl.Mcode==4 | tbl.Mcode==8) = 23;
mcodetmp = unique(tbl.Mcodemerg);
mdlpct = [];
mdlpct(:,1) = mcodetmp';
for ii = 1:length(mcodetmp)
    modlidx = tbl.Mcodemerg == mcodetmp(ii);
    mdlpct(ii,2) = mean(modlidx)*100;
end

mostidx = mdlpct(:,2)==max(mdlpct(:,2));
mostcode = tbl.Mcodemerg == mdlpct(mostidx, 1);
% txt = sprintf('%s, %s:%.1f%%', thisfilename(9:end-4), Mnamemerg{mdlpct(mostidx, 1)-10}, max(mdlpct(:,2)));

% Plot stacked bar
stackcolor = [49,130,189; 
    251,106,74; 
    189,189,189;]/255;
figure; 
for ii = 1:length(mdlpct(:,2))
    b = bar(sum(mdlpct(ii:end, 2)/100), 'FaceColor', stackcolor(ii,:));
    b.LineWidth = 1.3;
    b.BarWidth = 0.6;
    hold on
end
ylim([0, 1])
box off
set(gca, 'YTick',0:0.2:1, 'LineWidth',1.4)
set(gca, 'YTickLabel',{}, 'XTickLabel',{})

% Plot Histogram
if mdlpct(mostidx, 1) == 21
    y = [tbl.SA(mostcode);tbl.SD_SC(mostcode)];
    thisfacecolor = stackcolor(1,:);   
elseif mdlpct(mostidx, 1) == 22 
    y = tbl.SD_SC(mostcode);
    thisfacecolor = stackcolor(2,:);
elseif mdlpct(mostidx, 1) == 23 && mdlpct(1, 2) >= mdlpct(2, 2)
    y = [tbl.SA(tbl.Mcode==2 | tbl.Mcode==6); tbl.SD_SC(tbl.Mcode==7)];
    thisfacecolor =  stackcolor(1,:);
elseif mdlpct(mostidx, 1) == 23 && mdlpct(1, 2) <= mdlpct(2, 2)
    y = tbl.SD_SC(tbl.Mcode==3);
    thisfacecolor =  stackcolor(2,:);
end

% npara = length(y);
figure; histogram(y, 50, 'EdgeColor','none', 'Normalization','probability', 'FaceColor', thisfacecolor, 'FaceAlpha', 1)
box off
ylim([0, 0.08])
xlim([0.2, 0.7])
set(gca, 'XTick', 0.1:0.1:0.9, 'YTick', 0:0.02:0.08, 'LineWidth', 1.4)
set(gca, 'YTickLabel',{}, 'XTickLabel',{})


%% Calculate 95% CI
allresfiles = dir('R2MATLAB/allACE_twin_myiscgammahigh*.csv');
% thisfilename = 'allACE_mcoh.csv';
for ii = length(allresfiles):-1:1
    thisfilename = fullfile(allresfiles(ii).folder, allresfiles(ii).name);
    tbl = readtable(thisfilename);
    
    [mu, std, muci] = normfit(tbl.SA);
    SA_std(ii,:) = [mu-std, mu+std];
    SA_hf_std(ii,:) = [mu-std/2, mu+std/2];
    SA_muci(ii,:) = muci';
    [mu, std, muci] = normfit(tbl.SD_SC);
    SC_std(ii,:) = [mu-std, mu+std];
    SC_hf_std(ii,:) = [mu-std/2, mu+std/2];
    SC_muci(ii,:) = muci';
    [mu, std, muci] = normfit(tbl.SE);
    SE_std(ii,:) = [mu-std, mu+std];
    SE_hf_std(ii,:) = [mu-std/2, mu+std/2];
    SE_muci(ii,:) = muci';
end

[SA_std, SC_std, SE_std]




