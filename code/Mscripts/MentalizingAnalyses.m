%% For Mentalization
% load guess data, load rdm data?
clear;home

colorms = [1,0,0; 0.5,0.5,0.5];
colords = [0,1,0; 0.5,0.5,0.5];
colormd = [1,0,0; 0,1,0];
taskcolors = [lines(2), lines(2)*1.7]';
taskcolors =  min(taskcolors,1);
taskcolors =  reshape(taskcolors,3,4)';

tblguess = readtable('result_files\Guessin1sessions1201-18;43;41.csv');  %Guessin1sessions1116-09;24;22.csv
% tblguess = sortrows(tblguess, 'twinsNum');
tblrdm = readtable('result_files\RDM2sessions1113-15;42;45.csv');
[tbltwins, tblstrangers] = TwinsOrStrangers(tblguess);

%{'T057', 'T020', 'T032', 'T086', 'T114', 'T053', 'T088', 'T112', 'T017','T066'}-----max ten MZ by rtweight
% 'T086','T028','T112','T013','T036','T035','T087','T020','T110','T114'-----max ten MZ by fitauc
% 'T078','T104','T096','T030', 'T044' -----max ten DZ by rtweight
% sameother = sortrows(FindStrinCell({'sunfanru','yulikun'}, tblstrangers.othername));
eraseMZ = FindStrinCell({'T057', 'T020', 'T032', 'T086', 'T114', 'T053', 'T088', 'T112', 'T017','T066'}, tblrdm.twinsNum);
eraseDZ = FindStrinCell({'T078', 'T104', 'T096'}, tblrdm.twinsNum);
eraseALL = unique([eraseMZ; eraseDZ]); %;sameother
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

%%
figure;
PlotErrorbar({tbltwinsmz.confcorrraw, tbltwinsdz.confcorrraw, tblstrangersmz.confcorrraw, tblstrangersdz.confcorrraw})
ylim([0,0.3])
title('raw guess confidence correlation')
set(gca,'xticklabel',{'mztwins','dztwins','mzstrangers','dzstrangers'})

figure;
PlotErrorbar({tbltwinsmz.confcorr_residhigh, tbltwinsdz.confcorr_residhigh, tblstrangersmz.confcorr_residhigh, tblstrangersdz.confcorr_residhigh})
ylim([0,0.3])
title('resid guess confidence correlation')
set(gca,'xticklabel',{'mztwins','dztwins','mzstrangers','dzstrangers'})

%%
figure;
PlotErrorbar([tbltwins.myauc, tblstrangers.myauc, mean([tblrdm.myauc1,tblrdm.myauc2],2)])
ylim([0.5,1])
title('raw AUC')
set(gca,'xticklabel',{'twins','strangers','self'})

figure;
PlotErrorbar([tbltwins.myaucresidhigh, tblstrangers.myaucresidhigh, mean([tblrdm.myaucresid1,tblrdm.myaucresid2],2)])
ylim([0.5,1])
title('resid AUC')
set(gca,'xticklabel',{'twins','strangers','self'})

%%
figure;
PlotErrorbar({tbltwinsmz.mcoh, tbltwinsdz.mcoh})
ylim([6,15])
title('Difficulty')
set(gca,'xticklabel',{'MZ','DZ'})

figure;
PlotErrorbar({tbltwinsmz.myauc, tbltwinsdz.myauc})
ylim([0.4,0.6])
title('AUC')
set(gca,'xticklabel',{'MZ','DZ'})

figure;
PlotErrorbar({tbltwinsmz.accuracy, tbltwinsdz.accuracy})
ylim([0.4,0.6])
title('Accuracy')
set(gca,'xticklabel',{'MZ','DZ'})

figure;
PlotErrorbar({tbltwinsmz.myrtcorr, tbltwinsdz.myrtcorr})
ylim([-1, 0])
title('Corr\_RT\_conf')
set(gca,'xticklabel',{'MZ','DZ'})

figure;
PlotErrorbar({tbltwinsmz.mrtime, tbltwinsdz.mrtime})
ylim([1, 2])
title('Mean RT')
set(gca,'xticklabel',{'MZ','DZ'})

%% 方差是离均平方和
txt = sprintf('自评和评价twins时raw AUC的关系');
figure;
PlotScatterLine(mean([tblrdm.myauc1,tblrdm.myauc2],2), tbltwins.myauc, txt)
xlabel('self rdm auc');ylabel('self guess auc');
ylim([0.35,0.75]);xlim([0.35,0.85])

txt = sprintf('自评和评价stranger时raw AUC的关系');
figure;
PlotScatterLine(mean([tblrdm.myauc1,tblrdm.myauc2],2), tblstrangers.myauc, txt)
xlabel('self rdm auc');ylabel('self guess auc');
ylim([0.35,0.75]);xlim([0.35,0.85])

txt = sprintf('自评和评价twins时resid AUC的关系');
figure;
PlotScatterLine(mean([tblrdm.myaucresid1,tblrdm.myaucresid2],2), tbltwins.myaucresidhigh, txt)
xlabel('self rdm auc');ylabel('self guess auc');
ylim([0.35,0.75]);xlim([0.35,0.85])

txt = sprintf('自评和评价stranger时resid AUC的关系');
figure;
PlotScatterLine(mean([tblrdm.myaucresid1,tblrdm.myaucresid2],2), tblstrangers.myaucresidhigh, txt)
xlabel('self rdm auc');ylabel('self guess auc');
ylim([0.35,0.75]);xlim([0.35,0.85])
% xlim([0,1])
% ylim([0,1])
%%
txt = sprintf('MZ自评和评价twins时raw AUC的关系');
figure;
PlotScatterLine(mean([tblrdmmz.myauc1,tblrdmmz.myauc2],2), tbltwinsmz.myauc, txt)
xlabel('self rdm auc');ylabel('self guess auc');

txt = sprintf('MZ自评和评价twins时resid AUC的关系');
figure;
PlotScatterLine(mean([tblrdmmz.myaucresid1,tblrdmmz.myaucresid2],2), tbltwinsmz.myaucresidhigh, txt)
xlabel('self rdm auc');ylabel('self guess auc');
ylim([0.35,0.75]);xlim([0.35,0.85])

txt = sprintf('DZ自评和评价twins时raw AUC的关系');
figure;
PlotScatterLine(mean([tblrdmdz.myauc1,tblrdmdz.myauc2],2), tbltwinsdz.myauc, txt)
xlabel('self rdm auc');ylabel('self guess auc');

txt = sprintf('DZ自评和评价twins时resid AUC的关系');
figure;
PlotScatterLine(mean([tblrdmdz.myaucresid1,tblrdmdz.myaucresid2],2), tbltwinsdz.myaucresidhigh, txt)
xlabel('self rdm auc');ylabel('self guess auc');
ylim([0.35,0.75]);xlim([0.35,0.85])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
txt = sprintf('MZ自评和评价strangers时raw AUC的关系');
figure;
PlotScatterLine(mean([tblrdmmz.myauc1,tblrdmmz.myauc2],2), tblstrangersmz.myauc, txt)
xlabel('self rdm auc');ylabel('self guess auc');

txt = sprintf('MZ自评和评价strangers时resid AUC的关系');
figure;
PlotScatterLine(mean([tblrdmmz.myaucresid1,tblrdmmz.myaucresid2],2), tblstrangersmz.myaucresidhigh, txt)
xlabel('self rdm auc');ylabel('self guess auc');
ylim([0.35,0.75]);xlim([0.35,0.85])

txt = sprintf('DZ自评和评价strangers时raw AUC的关系');
figure;
PlotScatterLine(mean([tblrdmdz.myauc1,tblrdmdz.myauc2],2), tblstrangersdz.myauc, txt)
xlabel('self rdm auc');ylabel('self guess auc');

txt = sprintf('DZ自评和评价strangers时resid AUC的关系');
figure;
PlotScatterLine(mean([tblrdmdz.myaucresid1,tblrdmdz.myaucresid2],2), tblstrangersdz.myaucresidhigh, txt)
xlabel('self rdm auc');ylabel('self guess auc');
ylim([0.35,0.75]);xlim([0.35,0.85])

%% myauc & otherauc
txt = sprintf('评价twins时双方raw AUC的关系');
figure;
PlotScatterLine(tbltwins.myauc, tbltwins.otherauc, txt)
xlabel('my guess auc');ylabel('other rdm auc');

txt = sprintf('评价twins时双方resid AUC的关系');
figure;
PlotScatterLine(tbltwins.myaucresidhigh, tbltwins.otheraucresidhigh, txt)
xlabel('my guess auc');ylabel('other rdm auc');

txt = sprintf('评价strangers时双方raw AUC的关系');
figure;
PlotScatterLine(tblstrangers.myauc, tblstrangers.otherauc, txt)
xlabel('my guess auc');ylabel('other rdm auc');

txt = sprintf('评价strangers时双方resid AUC的关系');
figure;
PlotScatterLine(tblstrangers.myaucresidhigh, tblstrangers.otheraucresidhigh, txt)
xlabel('my guess auc');ylabel('other rdm auc');

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
txt = sprintf('MZ评价twins时双方raw AUC的关系');
figure;
PlotScatterLine(tbltwinsmz.myauc, tbltwinsmz.otherauc, txt)
xlabel('my guess auc');ylabel('other rdm auc');

txt = sprintf('MZ评价twins时双方resid AUC的关系');
figure;
PlotScatterLine(tbltwinsmz.myaucresidhigh, tbltwinsmz.otheraucresidhigh, txt)
xlabel('my guess auc');ylabel('other rdm auc');

txt = sprintf('MZ评价strangers时双方raw AUC的关系');
figure;
PlotScatterLine(tblstrangersmz.myauc, tblstrangersmz.otherauc, txt)
xlabel('my guess auc');ylabel('other rdm auc');

txt = sprintf('MZ评价strangers时双方resid AUC的关系');
figure;
PlotScatterLine(tblstrangersmz.myaucresidhigh, tblstrangersmz.otheraucresidhigh, txt)
xlabel('my guess auc');ylabel('other rdm auc');


%%%%%%%%%%%%%%%%%%%%%%%%

txt = sprintf('DZ评价twins时双方raw AUC的关系');
figure;
PlotScatterLine(tbltwinsdz.myauc, tbltwinsdz.otherauc, txt)
xlabel('my guess auc');ylabel('other rdm auc');

txt = sprintf('DZ评价twins时双方resid AUC的关系');
figure;
PlotScatterLine(tbltwinsdz.myaucresidhigh, tbltwinsdz.otheraucresidhigh, txt)
xlabel('my guess auc');ylabel('other rdm auc');

txt = sprintf('DZ评价strangers时双方raw AUC的关系');
figure;
PlotScatterLine(tblstrangersdz.myauc, tblstrangersdz.otherauc, txt)
xlabel('my guess auc');ylabel('other rdm auc');

txt = sprintf('DZ评价strangers时双方resid AUC的关系');
figure;
PlotScatterLine(tblstrangersdz.myaucresidhigh, tblstrangersdz.otheraucresidhigh, txt)
xlabel('my guess auc');ylabel('other rdm auc');

%% Mentalization ICC
selfaucresidmz = [tblrdmmz.myaucresid1(1:2:end), tblrdmmz.myaucresid2(1:2:end), tblrdmmz.myaucresid1(2:2:end), tblrdmmz.myaucresid2(2:2:end)];
selfaucresiddz = [tblrdmdz.myaucresid1(1:2:end), tblrdmdz.myaucresid2(1:2:end), tblrdmdz.myaucresid1(2:2:end), tblrdmdz.myaucresid2(2:2:end)]; 

twinsaucresidmz = [tbltwinsmz.myaucresidhigh(1:2:end), tbltwinsmz.myaucresidhigh(2:2:end)];
twinsaucresiddz = [tbltwinsdz.myaucresidhigh(1:2:end), tbltwinsdz.myaucresidhigh(2:2:end)];
strangersaucresidmz = [tblstrangersmz.myaucresidhigh(1:2:end), tblstrangersmz.myaucresidhigh(2:2:end)];
strangersaucresiddz = [tblstrangersdz.myaucresidhigh(1:2:end), tblstrangersdz.myaucresidhigh(2:2:end)];

twinsrtcorrdz = [tbltwinsdz.myrtcorr(1:2:end), tbltwinsdz.myrtcorr(2:2:end)];
rmpos = all(twinsrtcorrdz<0, 2);

twinsaucrawmz = [tbltwinsmz.myauc(1:2:end), tbltwinsmz.myauc(2:2:end)];
twinsaucrawdz = [tbltwinsdz.myauc(1:2:end), tbltwinsdz.myauc(2:2:end)];
% twinsaucrawdz = twinsaucrawdz(rmpos, :);
strangersaucrawmz = [tblstrangersmz.myauc(1:2:end), tblstrangersmz.myauc(2:2:end)];
strangersaucrawdz = [tblstrangersdz.myauc(1:2:end), tblstrangersdz.myauc(2:2:end)];

twinsrtweightmz = [tbltwinsmz.rtweight(1:2:end), tbltwinsmz.rtweight(2:2:end)];
twinsrtweightdz = [tbltwinsdz.rtweight(1:2:end), tbltwinsdz.rtweight(2:2:end)];
strangersrtweightmz = [tblstrangersmz.rtweight(1:2:end), tblstrangersmz.rtweight(2:2:end)];
strangersrtweightdz = [tblstrangersdz.rtweight(1:2:end), tblstrangersdz.rtweight(2:2:end)];

twinsmyiscgammamz = [tbltwinsmz.myiscgamma(1:2:end), tbltwinsmz.myiscgamma(2:2:end)];
twinsmyiscgammadz = [tbltwinsdz.myiscgamma(1:2:end), tbltwinsdz.myiscgamma(2:2:end)];
strangersmyiscgammamz = [tblstrangersmz.myiscgamma(1:2:end), tblstrangersmz.myiscgamma(2:2:end)];
strangersmyiscgammadz = [tblstrangersdz.myiscgamma(1:2:end), tblstrangersdz.myiscgamma(2:2:end)];

twinsmyiscgammahighmz = [tbltwinsmz.myiscgammahigh(1:2:end), tbltwinsmz.myiscgammahigh(2:2:end)];
twinsmyiscgammahighdz = [tbltwinsdz.myiscgammahigh(1:2:end), tbltwinsdz.myiscgammahigh(2:2:end)];
strangersmyiscgammahighmz = [tblstrangersmz.myiscgammahigh(1:2:end), tblstrangersmz.myiscgammahigh(2:2:end)];
strangersmyiscgammahighdz = [tblstrangersdz.myiscgammahigh(1:2:end), tblstrangersdz.myiscgammahigh(2:2:end)];

% twinsfitaucmz = [tbltwinsmz.myfitauc(1:2:end), tbltwinsmz.myfitauc(2:2:end)];
% twinsfitaucdz = [tbltwinsdz.myfitauc(1:2:end), tbltwinsdz.myfitauc(2:2:end)];
% strangersfitaucmz = [tblstrangersmz.myfitauc(1:2:end), tblstrangersmz.myfitauc(2:2:end)];
% strangersfitaucdz = [tblstrangersdz.myfitauc(1:2:end), tblstrangersdz.myfitauc(2:2:end)];

twinsfitaucmz = [tbltwinsmz.myfitauc(1:2:end), tbltwinsmz.myfitauc(2:2:end)];
twinsfitaucdz = [tbltwinsdz.myfitauc(1:2:end), tbltwinsdz.myfitauc(2:2:end)];
strangersfitaucmz = [tblstrangersmz.myfitauc(1:2:end), tblstrangersmz.myfitauc(2:2:end)];
strangersfitaucdz = [tblstrangersdz.myfitauc(1:2:end), tblstrangersdz.myfitauc(2:2:end)];

twinsotheraucmz = [tbltwinsmz.otherauc(1:2:end), tbltwinsmz.otherauc(2:2:end)];
twinsotheraucdz = [tbltwinsdz.otherauc(1:2:end), tbltwinsdz.otherauc(2:2:end)];
strangersotheraucmz = [tblstrangersmz.otherauc(1:2:end), tblstrangersmz.otherauc(2:2:end)];
strangersotheraucdz = [tblstrangersdz.otherauc(1:2:end), tblstrangersdz.otherauc(2:2:end)];

twinsotherrtcorrmz = [tbltwinsmz.otherrtcorr(1:2:end), tbltwinsmz.otherrtcorr(2:2:end)];
twinsotherrtcorrdz = [tbltwinsdz.otherrtcorr(1:2:end), tbltwinsdz.otherrtcorr(2:2:end)];
strangersotherrtcorrmz = [tblstrangersmz.otherrtcorr(1:2:end), tblstrangersmz.otherrtcorr(2:2:end)];
strangersotherrtcorrdz = [tblstrangersdz.otherrtcorr(1:2:end), tblstrangersdz.otherrtcorr(2:2:end)];

twinsconfcorrrawmz = [tbltwinsmz.confcorrraw(1:2:end), tbltwinsmz.confcorrraw(2:2:end)];
twinsconfcorrrawdz = [tbltwinsdz.confcorrraw(1:2:end), tbltwinsdz.confcorrraw(2:2:end)];
strangersconfcorrrawmz = [tblstrangersmz.confcorrraw(1:2:end), tblstrangersmz.confcorrraw(2:2:end)];
strangersconfcorrrawdz = [tblstrangersdz.confcorrraw(1:2:end), tblstrangersdz.confcorrraw(2:2:end)];

twinsconfcorrresidmz = [tbltwinsmz.confcorr_residhigh(1:2:end), tbltwinsmz.confcorr_residhigh(2:2:end)];
twinsconfcorrresiddz = [tbltwinsdz.confcorr_residhigh(1:2:end), tbltwinsdz.confcorr_residhigh(2:2:end)];
strangersconfcorrresidmz = [tblstrangersmz.confcorr_residhigh(1:2:end), tblstrangersmz.confcorr_residhigh(2:2:end)];
strangersconfcorrresiddz = [tblstrangersdz.confcorr_residhigh(1:2:end), tblstrangersdz.confcorr_residhigh(2:2:end)];

% selftotwins_mz = twinsaucresidmz ./ [mean(selfaucresidmz(:,1:2),2), mean(selfaucresidmz(:,3:4),2)];
% selftotwins_dz = twinsaucresiddz ./ [mean(selfaucresiddz(:,1:2),2), mean(selfaucresiddz(:,3:4),2)];
% selftostrangers_mz = strangersaucresidmz ./ [mean(selfaucresidmz(:,1:2),2), mean(selfaucresidmz(:,3:4),2)];
% selftostrangers_dz = strangersaucresiddz ./ [mean(selfaucresiddz(:,1:2),2), mean(selfaucresiddz(:,3:4),2)];

%% Find Outliners in MZ

diffmz = [twinsrtweightmz(:,1)-twinsrtweightmz(:,2), strangersrtweightmz(:,1)-strangersrtweightmz(:,2)];
diffdz = [twinsrtweightdz(:,1)-twinsrtweightdz(:,2), strangersrtweightdz(:,1)-strangersrtweightdz(:,2)];
Cdistmz = sqrt(sum(diffmz.^2, 2));
Cdistdz = sqrt(sum(diffdz.^2, 2));

mztwinNum = tblrdmmz.twinsNum(1:2:end);
mztwinNum(:,2) = num2cell(Cdistmz);
% mztwinNum(:,3) = num2cell(abs(meandiffmz));
mztwinNum = sortrows(mztwinNum, -2);

dztwinNum = tblrdmdz.twinsNum(1:2:end);
dztwinNum(:,2) = num2cell(Cdistdz);
% mztwinNum(:,3) = num2cell(abs(meandiffmz));
dztwinNum = sortrows(dztwinNum, -2);

%% Plot OutLiners
[icc_voi, lenvoi]= PlotPairTwins(twinsotheraucmz, strangersotheraucmz);
txt1 = sprintf('other AUC \n MZtwins ICC= %.3f',icc_voi(1));
txt2 = sprintf('   MZstrangers ICC= %.3f',icc_voi(2));
ylim([0, 1])
title([txt1, txt2])
hold on
plot([1,lenvoi], [0.5, 0.5], 'k--')

[icc_voi, lenvoi]= PlotPairTwins(twinsotheraucdz, strangersotheraucdz);
txt1 = sprintf('other AUC \n DZtwins ICC= %.3f',icc_voi(1));
txt2 = sprintf('   DZstrangers ICC= %.3f',icc_voi(2));
ylim([0, 1])
title([txt1, txt2])
hold on
plot([1,lenvoi], [0.5, 0.5], 'k--')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[icc_voi, lenvoi]= PlotPairTwins(twinsotherrtcorrmz, strangersotherrtcorrmz);
txt1 = sprintf('other rtcorr \n MZtwins ICC= %.3f',icc_voi(1));
txt2 = sprintf('   MZstrangers ICC= %.3f',icc_voi(2));
ylim([-1, 1])
title([txt1, txt2])
hold on
plot([1,lenvoi], [0, 0], 'k--')

[icc_voi, lenvoi]= PlotPairTwins(twinsotherrtcorrdz, strangersotherrtcorrdz);
txt1 = sprintf('other rtcorr \n DZtwins ICC= %.3f',icc_voi(1));
txt2 = sprintf('   DZstrangers ICC= %.3f',icc_voi(2));
ylim([-1, 1])
title([txt1, txt2])
hold on
plot([1,lenvoi], [0, 0], 'k--')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[icc_voi, lenvoi]= PlotPairTwins(twinsaucrawmz, strangersaucrawmz);
txt1 = sprintf('Raw AUC \n MZtwins ICC= %.3f',icc_voi(1));
txt2 = sprintf('   MZstrangers ICC= %.3f',icc_voi(2));
ylim([0,1])
title([txt1, txt2])
hold on
plot([1,lenvoi], [0.5, 0.5], 'k--')
% sameother = sortrows(FindStrinCell({'sunfanru','yulikun'}, tblstrangersmz.othername));
% hold on 
% for ii = 1:length(sameother)
%     plot( ceil(sameother(ii)/2), tblstrangersmz.myauc(sameother(ii)), 'go')
%     hold on
%     plot(ceil(sameother(ii)/2), tblstrangersmz.myauc(sameother(ii)),'go')
%     hold on
% end

[icc_voi, lenvoi]= PlotPairTwins(twinsaucrawdz, strangersaucrawdz);
txt1 = sprintf('Raw AUC \n DZtwins ICC= %.3f',icc_voi(1));
txt2 = sprintf('   DZstrangers ICC= %.3f',icc_voi(2));
ylim([0,1])
title([txt1, txt2])
hold on
plot([1,lenvoi], [0.5, 0.5], 'k--')
% sameother = sortrows(FindStrinCell({'sunfanru','yulikun'}, tblstrangersdz.othername));
% hold on 
% for ii = 1:length(sameother)
%     plot(ceil(sameother(ii)/2), tblstrangersdz.myauc(sameother(ii)), 'go')
%     hold on
%     plot(ceil(sameother(ii)/2), tblstrangersdz.myauc(sameother(ii)),'go')
%     hold on
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[icc_voi, lenvoi]= PlotPairTwins(twinsrtweightmz, strangersrtweightmz);
txt1 = sprintf('RT weight \n MZtwins ICC= %.3f',icc_voi(1));
txt2 = sprintf('   MZstrangers ICC= %.3f',icc_voi(2));
ylim([-1,1])
title([txt1, txt2])
hold on
plot([1,lenvoi], [0, 0], 'k--')
hold on
plot(Cdistmz, 'm--')
% sameother = sortrows(FindStrinCell({'sunfanru','yulikun'}, tblstrangersmz.othername));
% hold on 
% for ii = 1:length(sameother)
%     plot( ceil(sameother(ii)/2), tblstrangersmz.rtweight(sameother(ii)), 'go')
%     hold on
%     plot(ceil(sameother(ii)/2), tblstrangersmz.rtweight(sameother(ii)),'go')
%     hold on
% end

[icc_voi, lenvoi]= PlotPairTwins(twinsrtweightdz, strangersrtweightdz);
txt1 = sprintf('RT weight \n DZtwins ICC= %.3f',icc_voi(1));
txt2 = sprintf('   DZstrangers ICC= %.3f',icc_voi(2));
ylim([-1,1])
title([txt1, txt2])
hold on
plot([1,lenvoi], [0, 0], 'k--')
hold on
plot(Cdistdz, 'm--')
% sameother = sortrows(FindStrinCell({'sunfanru','yulikun'}, tblstrangersdz.othername));
% hold on 
% for ii = 1:length(sameother)
%     plot(ceil(sameother(ii)/2), tblstrangersdz.rtweight(sameother(ii)), 'go')
%     hold on
%     plot(ceil(sameother(ii)/2), tblstrangersdz.rtweight(sameother(ii)),'go')
%     hold on
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

voi = twinsaucresidmz; % [auc1, auc2]
icc_voi = ICC(voi,'1-1');
mvoi = mean(mean(voi));
% diffvoi = max(voi,[],2) -  min(voi,[],2);
lenvoi = length(voi);
tmpnum = voi>=mvoi;
numpair = sum(tmpnum(:,1)~=tmpnum(:,2));
% voi = mapminmax(voi(:)',0,1);
% voi = reshape(voi,lenvoi,2); % normalize
txt1 = sprintf('AUCresid distribution \n MZtwins ICC= %.3f',icc_voi);
figure;
for ii = 1:lenvoi
    plot(ii, voi(ii,1),'ro')
    hold on
    plot(ii, voi(ii,2),'ro')
    hold on
    plot([ii,ii],[voi(ii,1),voi(ii,2)],'r-')
    hold on
end

voi = strangersaucresidmz; % [auc1, auc2]
icc_voi = ICC(voi,'1-1');
mvoi = mean(mean(voi));
% diffvoi = max(voi,[],2) -  min(voi,[],2);
lenvoi = length(voi);
tmpnum = voi>=mvoi;
numpair = sum(tmpnum(:,1)~=tmpnum(:,2));
% voi = mapminmax(voi(:)',0,1);
% voi = reshape(voi,lenvoi,2); % normalize
txt2 = sprintf('   MZstrangers ICC= %.3f',icc_voi);
% figure;
for ii = 1:lenvoi
    plot(ii, voi(ii,1),'bo')
    hold on
    plot(ii, voi(ii,2),'bo')
    hold on
    plot([ii,ii],[voi(ii,1),voi(ii,2)],'b-')
    hold on
end
ylim([0,1])
title([txt1, txt2])
% hold on
% plot(Cdistmz, 'm--')
% atmp = sortrows(Cdistmzrtweight,-1);
% hold on
% plot([1,lenvoi], [atmp(11), atmp(11)], 'k--')
hold on
plot([1,lenvoi], [0.5, 0.5], 'k--')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

voi = twinsaucresiddz; % [auc1, auc2]
icc_voi = ICC(voi,'1-1');
mvoi = mean(mean(voi));
% diffvoi = max(voi,[],2) -  min(voi,[],2);
lenvoi = length(voi);
tmpnum = voi>=mvoi;
numpair = sum(tmpnum(:,1)~=tmpnum(:,2));
% voi = mapminmax(voi(:)',0,1);
% voi = reshape(voi,lenvoi,2); % normalize
txt1 = sprintf('AUCresid distribution \n DZtwins ICC= %.3f',icc_voi);
figure;
for ii = 1:lenvoi
    plot(ii, voi(ii,1),'ro')
    hold on
    plot(ii, voi(ii,2),'ro')
    hold on
    plot([ii,ii],[voi(ii,1),voi(ii,2)],'r-')
    hold on
end

voi = strangersaucresiddz; % [auc1, auc2]
icc_voi = ICC(voi,'1-1');
mvoi = mean(mean(voi));
% diffvoi = max(voi,[],2) -  min(voi,[],2);
lenvoi = length(voi);
tmpnum = voi>=mvoi;
numpair = sum(tmpnum(:,1)~=tmpnum(:,2));
% voi = mapminmax(voi(:)',0,1);
% voi = reshape(voi,lenvoi,2); % normalize
txt2 = sprintf('   DZstrangers ICC= %.3f',icc_voi);
% figure;
for ii = 1:lenvoi
    plot(ii, voi(ii,1),'bo')
    hold on
    plot(ii, voi(ii,2),'bo')
    hold on
    plot([ii,ii],[voi(ii,1),voi(ii,2)],'b-')
    hold on
end
ylim([0,1])
title([txt1, txt2])
% hold on
% plot(Cdistmz, 'm--')
% atmp = sortrows(Cdistmzrtweight,-1);
% hold on
% plot([1,lenvoi], [atmp(11), atmp(11)], 'k--')
hold on
plot([1,lenvoi], [0.5, 0.5], 'k--')


%%
[icc_voi, lenvoi]= PlotPairTwins(twinsconfcorrrawmz, strangersconfcorrrawmz);
txt1 = sprintf('Conf Correlation \n MZtwins ICC= %.3f',icc_voi(1));
txt2 = sprintf('   MZstrangers ICC= %.3f',icc_voi(2));
ylim([-0.4,1])
title([txt1, txt2])
hold on
plot([1,lenvoi], [0, 0], 'k--')

[icc_voi, lenvoi]= PlotPairTwins(twinsconfcorrrawdz, strangersconfcorrrawdz);
txt1 = sprintf('Conf Correlation \n DZtwins ICC= %.3f',icc_voi(1));
txt2 = sprintf('   DZstrangers ICC= %.3f',icc_voi(2));
ylim([-0.4,1])
title([txt1, txt2])
hold on
plot([1,lenvoi], [0, 0], 'k--')

btmp = {twinsconfcorrrawmz(:), strangersconfcorrrawmz(:), twinsconfcorrrawdz(:), strangersconfcorrrawdz(:)};
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
ylim([0, 0.5])
% hold on 
% plot([0,5],[0.5,0.5],'k--')
% set(gca, 'YTick', 0.1:0.1:1, 'LineWidth', 1.4)
% set(gca, 'YTickLabel', {}, 'XTickLabel', {})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[icc_voi, lenvoi]= PlotPairTwins(twinsconfcorrresidmz, strangersconfcorrresidmz);
txt1 = sprintf('Conf resid Correlation \n MZtwins ICC= %.3f',icc_voi(1));
txt2 = sprintf('   MZstrangers ICC= %.3f',icc_voi(2));
ylim([-0.4,1])
title([txt1, txt2])
hold on
plot([1,lenvoi], [0, 0], 'k--')

[icc_voi, lenvoi]= PlotPairTwins(twinsconfcorrresiddz, strangersconfcorrresiddz);
txt1 = sprintf('Conf resid Correlation \n DZtwins ICC= %.3f',icc_voi(1));
txt2 = sprintf('   DZstrangers ICC= %.3f',icc_voi(2));
ylim([-0.4,1])
title([txt1, txt2])
hold on
plot([1,lenvoi], [0, 0], 'k--')

btmp = {twinsconfcorrresidmz(:), strangersconfcorrresidmz(:), twinsconfcorrresiddz(:), strangersconfcorrresiddz(:)};
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
ylim([0, 0.5])

%%
txt = sprintf('MZ自评和评价twins时 rtweight 的关系');
figure;
PlotScatterLine(mean([tblrdmmz.myrtcorr1,tblrdmmz.myrtcorr2],2), tbltwinsmz.rtweight, txt)
xlabel('self rdm rtweight');ylabel('self guess rtweight');
ylim([-1,0.5]);xlim([-1,0.5])

txt = sprintf('MZ自评和评价stranger时 rtweight 的关系');
figure;
PlotScatterLine(mean([tblrdmmz.myrtcorr1,tblrdmmz.myrtcorr2],2), tblstrangersmz.rtweight, txt)
xlabel('self rdm rtweight');ylabel('self guess rtweight');
ylim([-1,0.5]);xlim([-1,0.5])

txt = sprintf('DZ自评和评价twins时 rtweight 的关系');
figure;
PlotScatterLine(mean([tblrdmdz.myrtcorr1,tblrdmdz.myrtcorr2],2), tbltwinsdz.rtweight, txt)
xlabel('self rdm rtweight');ylabel('self guess rtweight');
ylim([-1,0.5]);xlim([-1,0.5])

txt = sprintf('DZ自评和评价stranger时 rtweight 的关系');
figure;
PlotScatterLine(mean([tblrdmdz.myrtcorr1,tblrdmdz.myrtcorr2],2), tblstrangersdz.rtweight, txt)
xlabel('self rdm rtweight');ylabel('self guess rtweight');
ylim([-1,0.5]);xlim([-1,0.5])

%%

icc_mztwins_fitauc = TwinsBS_ICC(twinsfitaucmz, 0);
icc_dztwins_fitauc = TwinsBS_ICC(twinsfitaucdz, 0);
icc_mzstranger_fitauc = TwinsBS_ICC(strangersfitaucmz, 0);
icc_dzstranger_fitauc = TwinsBS_ICC(strangersfitaucdz, 0);

figure;
PlotHistograms(icc_mztwins_fitauc, icc_mzstranger_fitauc, 'MZ fit AUC Bootstrap',colorms)
legend('twin','stranger')
figure;
PlotHistograms(icc_dztwins_fitauc, icc_dzstranger_fitauc, 'DZ fit AUC Bootstrap',colords)
legend('twin','stranger')
figure;
PlotHistograms(icc_mztwins_fitauc, icc_dztwins_fitauc, 'fit AUC twins Bootstrap',colormd)
legend('MZ','DZ')

%%
icc_mztwins_mentalraw = TwinsBS_ICC(twinsaucrawmz, 0);
icc_dztwins_mentalraw = TwinsBS_ICC(twinsaucrawdz, 0);
icc_mzstranger_mentalraw = TwinsBS_ICC(strangersaucrawmz, 0);
icc_dzstranger_mentalraw = TwinsBS_ICC(strangersaucrawdz, 0);

icc_mztwins_mental = TwinsBS_ICC(twinsaucresidmz, 0);
icc_dztwins_mental = TwinsBS_ICC(twinsaucresiddz, 0);
icc_mzstranger_mental = TwinsBS_ICC(strangersaucresidmz, 0);
icc_dzstranger_mental = TwinsBS_ICC(strangersaucresiddz, 0);

icc_mztwins_rtweight = TwinsBS_ICC(twinsrtweightmz, 0);
icc_dztwins_rtweight = TwinsBS_ICC(twinsrtweightdz, 0);
icc_mzstranger_rtweight = TwinsBS_ICC(strangersrtweightmz, 0);
icc_dzstranger_rtweight = TwinsBS_ICC(strangersrtweightdz, 0);

icc_mztwins_myiscgamma = TwinsBS_ICC(twinsmyiscgammamz, 0);
icc_dztwins_myiscgamma = TwinsBS_ICC(twinsmyiscgammadz, 0);
icc_mzstranger_myiscgamma = TwinsBS_ICC(strangersmyiscgammamz, 0);
icc_dzstranger_myiscgamma = TwinsBS_ICC(strangersmyiscgammadz, 0);

icc_mztwins_myiscgammahigh = TwinsBS_ICC(twinsmyiscgammahighmz, 0);
icc_dztwins_myiscgammahigh = TwinsBS_ICC(twinsmyiscgammahighdz, 0);
icc_mzstranger_myiscgammahigh = TwinsBS_ICC(strangersmyiscgammahighmz, 0);
icc_dzstranger_myiscgammahigh = TwinsBS_ICC(strangersmyiscgammahighdz, 0);

%%
figure;
PlotHistograms(icc_mztwins_mentalraw, icc_mzstranger_mentalraw, 'MZ mental raw AUC Bootstrap',taskcolors([1 2],:))
legend('twin','stranger')
figure;
PlotHistograms(icc_dztwins_mentalraw, icc_dzstranger_mentalraw, 'DZ mental raw AUC Bootstrap',taskcolors([3 4],:))
legend('twin','stranger')
figure;
PlotHistograms(icc_mztwins_mentalraw, icc_dztwins_mentalraw, 'Twins raw AUC twins Bootstrap',taskcolors([1 3],:))
legend('MZ','DZ')
figure;
PlotHistograms(icc_mzstranger_mentalraw, icc_dzstranger_mentalraw, 'Strangers raw AUC twins Bootstrap',taskcolors([2 4],:))
legend('MZstranger','DZstranger')


%%%%%%%%%%%%%%%%%%%%%%%%%%


figure;
PlotHistograms(icc_mztwins_mental, icc_mzstranger_mental, 'MZ mental AUCresid Bootstrap',taskcolors([1 2],:))
legend('twin','stranger')
figure;
PlotHistograms(icc_dztwins_mental, icc_dzstranger_mental, 'DZ mental AUCresid Bootstrap',taskcolors([3 4],:))
legend('twin','stranger')
figure;
PlotHistograms(icc_mztwins_mental, icc_dztwins_mental, 'Twins AUCresid twins Bootstrap',taskcolors([1 3],:))
legend('MZ','DZ')
figure;
PlotHistograms(icc_mzstranger_mental, icc_dzstranger_mental, 'Strangers AUCresid twins Bootstrap',taskcolors([2 4],:))
legend('MZstranger','DZstranger')


%%%%%%%%%%%%%%%%%%%%%%%

figure;
PlotHistograms(icc_mztwins_rtweight, icc_mzstranger_rtweight, 'MZ RTweight Bootstrap',taskcolors([1 2],:))
legend('twin','stranger')
figure;
PlotHistograms(icc_dztwins_rtweight, icc_dzstranger_rtweight, 'DZ RTweight Bootstrap',taskcolors([3 4],:))
legend('twin','stranger')
figure;
PlotHistograms(icc_mztwins_rtweight, icc_dztwins_rtweight, 'Twins RTweight twins Bootstrap',taskcolors([1 3],:))
legend('MZ','DZ')
figure;
PlotHistograms(icc_mzstranger_rtweight, icc_dzstranger_rtweight, 'Strangers RTweight twins Bootstrap',taskcolors([2 4],:))
legend('MZstranger','DZstranger')

%%%%%%%%%%%%%%%%%%%%%%%%

figure;
PlotHistograms(icc_mztwins_myiscgamma, icc_mzstranger_myiscgamma, 'MZ myiscgamma Bootstrap',taskcolors([1 2],:))
legend('twin', 'stranger')
figure;
PlotHistograms(icc_dztwins_myiscgamma, icc_dzstranger_myiscgamma, 'DZ myiscgamma Bootstrap',taskcolors([3 4],:))
legend('twin', 'stranger')
figure;
PlotHistograms(icc_mztwins_myiscgamma, icc_dztwins_myiscgamma, 'Twins myiscgamma Bootstrap',taskcolors([1 3],:))
legend('MZ', 'DZ')
figure;
PlotHistograms(icc_mzstranger_myiscgamma, icc_dzstranger_myiscgamma, 'Strangers myiscgamma Bootstrap',taskcolors([2 4],:))
legend('MZstranger', 'DZstranger')

%%%%%%%%%%%%%%%%%%%%%%%
figure;
PlotHistograms(icc_mztwins_myiscgammahigh, icc_mzstranger_myiscgammahigh, 'MZ myiscgammahigh Bootstrap',taskcolors([1 2],:))
legend('twin','stranger')
figure;
PlotHistograms(icc_dztwins_myiscgammahigh, icc_dzstranger_myiscgammahigh, 'DZ myiscgammahigh Bootstrap',taskcolors([3 4],:))
legend('twin','stranger')
figure;
PlotHistograms(icc_mztwins_myiscgammahigh, icc_dztwins_myiscgammahigh, 'twins myiscgammahigh Bootstrap',taskcolors([1 3],:))
legend('MZ','DZ')
figure;
PlotHistograms(icc_mzstranger_myiscgammahigh, icc_dzstranger_myiscgammahigh, 'Strangers myiscgammahigh Bootstrap',taskcolors([2 4],:))
legend('MZstranger', 'DZstranger')


%%
icc_mztwins_randperm_rtweight = TwinsBS_ICC(twinsrtweightmz, 1);
icc_dztwins_randperm_rtweight = TwinsBS_ICC(twinsrtweightdz, 1);
icc_mzstranger_randperm_rtweight = TwinsBS_ICC(strangersrtweightmz, 1);
icc_dzstranger_randperm_rtweight = TwinsBS_ICC(strangersrtweightdz, 1);

icc_mztwins_randperm_mentalraw = TwinsBS_ICC(twinsaucrawmz, 1);
icc_dztwins_randperm_mentalraw = TwinsBS_ICC(twinsaucrawdz, 1);
icc_mzstranger_randperm_mentalraw = TwinsBS_ICC(strangersaucrawmz, 1);
icc_dzstranger_randperm_mentalraw = TwinsBS_ICC(strangersaucrawdz, 1);

icc_mztwins_randperm_mental = TwinsBS_ICC(twinsaucresidmz, 1);
icc_dztwins_randperm_mental = TwinsBS_ICC(twinsaucresiddz, 1);
icc_mzstranger_randperm_mental = TwinsBS_ICC(strangersaucresidmz, 1);
icc_dzstranger_randperm_mental = TwinsBS_ICC(strangersaucresiddz, 1);

icc_mztwins_randperm_myiscgamma = TwinsBS_ICC(twinsmyiscgammamz, 1);
icc_dztwins_randperm_myiscgamma = TwinsBS_ICC(twinsmyiscgammadz, 1);
icc_mzstranger_randperm_myiscgamma = TwinsBS_ICC(strangersmyiscgammamz, 1);
icc_dzstranger_randperm_myiscgamma = TwinsBS_ICC(strangersmyiscgammadz, 1);

icc_mztwins_randperm_myiscgammahigh = TwinsBS_ICC(twinsmyiscgammahighmz, 1);
icc_dztwins_randperm_myiscgammahigh = TwinsBS_ICC(twinsmyiscgammahighdz, 1);
icc_mzstranger_randperm_myiscgammahigh = TwinsBS_ICC(strangersmyiscgammahighmz, 1);
icc_dzstranger_randperm_myiscgammahigh = TwinsBS_ICC(strangersmyiscgammahighdz, 1);

%%
figure;
PlotHistograms(icc_mztwins_rtweight, icc_mztwins_randperm_rtweight, 'MZ rtweight ',[taskcolors(1,:); 0.5 0.5 0.5])
legend('MZtwin','random')
figure;
PlotHistograms(icc_dztwins_rtweight, icc_dztwins_randperm_rtweight, 'DZ rtweight ',[taskcolors(2,:); 0.5 0.5 0.5])
legend('DZtwin','random')
figure;
PlotHistograms(icc_mzstranger_rtweight, icc_mzstranger_randperm_rtweight, 'MZstranger rtweight ',[taskcolors(3,:); 0.5 0.5 0.5])
legend('MZstranger','random')
figure;
PlotHistograms(icc_dzstranger_rtweight, icc_dzstranger_randperm_rtweight, 'DZStrangers rtweight ',[taskcolors(4,:); 0.5 0.5 0.5])
legend('DZstranger', 'random')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
PlotHistograms(icc_mztwins_mentalraw, icc_mztwins_randperm_mentalraw, 'MZ AUC ',[taskcolors(1,:); 0.5 0.5 0.5])
legend('MZtwin','random')
figure;
PlotHistograms(icc_dztwins_mentalraw, icc_dztwins_randperm_mentalraw, 'DZ AUC ',[taskcolors(2,:); 0.5 0.5 0.5])
legend('DZtwin','random')
figure;
PlotHistograms(icc_mzstranger_mentalraw, icc_mzstranger_randperm_mentalraw, 'MZstranger AUC ',[taskcolors(3,:); 0.5 0.5 0.5])
legend('MZstranger','random')
figure;
PlotHistograms(icc_dzstranger_mentalraw, icc_dzstranger_randperm_mentalraw, 'DZStrangers AUC ',[taskcolors(4,:); 0.5 0.5 0.5])
legend('DZstranger', 'random')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
PlotHistograms(icc_mztwins_mental, icc_mztwins_randperm_mental, 'MZ AUC residual ',[taskcolors(1,:); 0.5 0.5 0.5])
legend('MZtwin','random')
figure;
PlotHistograms(icc_dztwins_mental, icc_dztwins_randperm_mental, 'DZ AUC residual ',[taskcolors(2,:); 0.5 0.5 0.5])
legend('DZtwin','random')
figure;
PlotHistograms(icc_mzstranger_mental, icc_mzstranger_randperm_mental, 'MZstranger AUC residual ',[taskcolors(3,:); 0.5 0.5 0.5])
legend('MZstranger','random')
figure;
PlotHistograms(icc_dzstranger_mental, icc_dzstranger_randperm_mental, 'DZStrangers AUC residual ',[taskcolors(4,:); 0.5 0.5 0.5])
legend('DZstranger', 'random')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
PlotHistograms(icc_mztwins_myiscgamma, icc_mztwins_randperm_myiscgamma, 'MZ myiscgamma ',[taskcolors(1,:); 0.5 0.5 0.5])
legend('MZtwin','random')
figure;
PlotHistograms(icc_dztwins_myiscgamma, icc_dztwins_randperm_myiscgamma, 'DZ myiscgamma ',[taskcolors(2,:); 0.5 0.5 0.5])
legend('DZtwin','random')
figure;
PlotHistograms(icc_mzstranger_myiscgamma, icc_mzstranger_randperm_myiscgamma, 'MZstranger myiscgamma ',[taskcolors(3,:); 0.5 0.5 0.5])
legend('MZstranger','random')
figure;
PlotHistograms(icc_dzstranger_myiscgamma, icc_dzstranger_randperm_myiscgamma, 'DZStrangers myiscgamma ',[taskcolors(4,:); 0.5 0.5 0.5])
legend('DZstranger', 'random')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
PlotHistograms(icc_mztwins_myiscgammahigh, icc_mztwins_randperm_myiscgammahigh, 'MZ myiscgammahigh ',[taskcolors(1,:); 0.5 0.5 0.5])
legend('MZtwin','random')
figure;
PlotHistograms(icc_dztwins_myiscgammahigh, icc_dztwins_randperm_myiscgammahigh, 'DZ myiscgammahigh ',[taskcolors(2,:); 0.5 0.5 0.5])
legend('DZtwin','random')
figure;
PlotHistograms(icc_mzstranger_myiscgammahigh, icc_mzstranger_randperm_myiscgammahigh, 'MZstranger myiscgammahigh ',[taskcolors(3,:); 0.5 0.5 0.5])
legend('MZstranger','random')
figure;
PlotHistograms(icc_dzstranger_myiscgammahigh, icc_dzstranger_randperm_myiscgammahigh, 'DZStrangers myiscgammahigh ',[taskcolors(4,:); 0.5 0.5 0.5])
legend('DZstranger', 'random')




%%
twinrdmguesaucmz = [mean([tblrdmmz.myaucresid1, tblrdmmz.myaucresid2],2), tbltwinsmz.myaucresidhigh];
twinrdmguesaucdz = [mean([tblrdmdz.myaucresid1, tblrdmdz.myaucresid2],2), tbltwinsdz.myaucresidhigh];
strangerrdmguesaucmz = [mean([tblrdmmz.myaucresid1, tblrdmmz.myaucresid2],2), tblstrangersmz.myaucresidhigh];
strangerrdmguesaucdz = [mean([tblrdmdz.myaucresid1, tblrdmdz.myaucresid2],2), tblstrangersdz.myaucresidhigh];
corr_twinmz_rdmguessauc = SelfBS(twinrdmguesaucmz, 'mz rdm guess twin auc correlation');
corr_twindz_rdmguessauc = SelfBS(twinrdmguesaucdz, 'dz rdm guess twin auc correlation');
corr_strangermz_rdmguessauc = SelfBS(strangerrdmguesaucmz, 'mz rdm guess stranger auc correlation');
corr_strangerdz_rdmguessauc = SelfBS(strangerrdmguesaucdz, 'dz rdm guess stranger auc correlation');

%% ?????
% icc_mz = ICC(selftotwins_mz,'1-1');
% icc_dz = ICC(selftotwins_dz, '1-1');
% voi = [selftotwins_dz; selftotwins_mz];
% randomicc = [];
% for ii = 1:1e5
%     randomvoi = [voi(:,1), voi(randperm(length(voi)),2)] ;
%     randomicc(ii) = ICC(randomvoi, '1-1');
% 
% end
% mean(randomicc<icc_mz)
% figure; histogram(randomicc)
% txt = sprintf('SelftoTwin ICC hist\nmzicc=%.3f p=%.3f, dzicc=%.3f p=%.3f', icc_mz, 1-mean(randomicc<icc_mz), icc_dz, 1-mean(randomicc<icc_dz));
% title(txt)
% 
% %%%%%%%%%%%%%
% icc_mz = ICC(selftostrangers_mz, '1-1');
% icc_dz = ICC(selftostrangers_dz, '1-1');
% voi = [selftostrangers_mz; selftostrangers_dz];
% randomicc = [];
% for ii = 1:1e5
%     randomvoi = [voi(:,1), voi(randperm(length(voi)),2)] ;
%     randomicc(ii) = ICC(randomvoi, '1-1');
% 
% end
% mean(randomicc<icc_mz)
% figure; histogram(randomicc)
% txt = sprintf('SelftoStrangers ICC hist\nmzicc=%.3f p=%.3f, dzicc=%.3f p=%.3f', icc_mz, 1-mean(randomicc<icc_mz), icc_dz, 1-mean(randomicc<icc_dz));
% title(txt)

%% ?????????

% distcostwin = diag(pdist2([tbltwinmentalizing.selfrdmauc1, tbltwinmentalizing.selfrdmauc2], ...
%     [tbltwinmentalizing.selfguessauc1, tbltwinmentalizing.selfguessauc2], 'cosine'));
% mzdist = distcostwin(tbltwinmentalizing.zyg==1);
% dzdist = distcostwin(tbltwinmentalizing.zyg==2);
% figure;
% PlotErrorbar({mzdist, dzdist})
% 
% distcostwinresid = diag(pdist2([tbltwinmentalizing.selfrdmaucresid1, tbltwinmentalizing.selfrdmaucresid2], ...
%     [tbltwinmentalizing.selfguessaucresid1, tbltwinmentalizing.selfguessaucresid2], 'cosine'));
% mzdistresid = distcostwinresid(tbltwinmentalizing.zyg==1);
% dzdistresid = distcostwinresid(tbltwinmentalizing.zyg==2);
% figure;
% PlotErrorbar({mzdistresid, dzdistresid})

%% p roboster confirm

% txt = sprintf('MZ自评和评价twins时resid AUC的关系');
% figure;
% PlotScatterLine(mean([tblrdmmz.myaucresid1,tblrdmmz.myaucresid2],2), tbltwinsmz.myaucresidhigh, txt)
% xlabel('self rdm auc');ylabel('self guess auc');

selfrdm_guess_corr = SelfBS([mean([tblrdmmz.myaucresid1,tblrdmmz.myaucresid2],2), tbltwinsmz.myaucresidhigh], 'self rdm&guess auc, p robustness confirm');

txt = sprintf('MZ自评和评价twins时ACCU的关系');
figure;
PlotScatterLine(mean([tblrdmmz.accuracy1,tblrdmmz.accuracy2],2), tbltwinsmz.accuracy, txt)
xlabel('self rdm accu');ylabel('other rdm accu');

txt = sprintf('MZ自评和评价stranger时ACCU的关系');
figure;
PlotScatterLine(mean([tblrdmmz.accuracy1,tblrdmmz.accuracy2],2), tblstrangersmz.accuracy, txt)
xlabel('self rdm accu');ylabel('other rdm accu');

txt = sprintf('DZ自评和评价twins时ACCU的关系');
figure;
PlotScatterLine(mean([tblrdmdz.accuracy1,tblrdmdz.accuracy2],2), tbltwinsdz.accuracy, txt)
xlabel('self rdm accu');ylabel('other rdm accu');

txt = sprintf('DZ自评和评价stranger时ACCU的关系');
figure;
PlotScatterLine(mean([tblrdmdz.accuracy1,tblrdmdz.accuracy2],2), tblstrangersdz.accuracy, txt)
xlabel('self rdm accu');ylabel('other rdm accu');

selfrdm_guess_corr = SelfBS([mean([tblrdmmz.accuracy1,tblrdmmz.accuracy2],2), tbltwinsmz.accuracy], 'self rdm&guess ACCU, p robustness confirm');


[rho, pval] = partialcorr([mean([tblrdmmz.myaucresid1,tblrdmmz.myaucresid2],2), tbltwinsmz.myaucresidhigh, mean([tblrdmmz.accuracy1,tblrdmmz.accuracy2],2), tbltwinsmz.accuracy])
rho = array2table(rho, ...
    'VariableNames',{'SelfRDMAUC','SelfGuessAUC','SelfRDMACCU','SelfGuessACCU'},...
    'RowNames',{'SelfRDMAUC','SelfGuessAUC','SelfRDMACCU','SelfGuessACCU'})

[rho, pval] = partialcorr(mean([tblrdmmz.myaucresid1,tblrdmmz.myaucresid2],2), tbltwinsmz.myaucresidhigh, [mean([tblrdmmz.accuracy1,tblrdmmz.accuracy2],2), tbltwinsmz.accuracy])
[rho, pval] = partialcorr(mean([tblrdmmz.myaucresid1,tblrdmmz.myaucresid2],2), tblstrangersmz.myaucresidhigh, [mean([tblrdmmz.accuracy1,tblrdmmz.accuracy2],2), tblstrangersmz.accuracy])
[rho, pval] = partialcorr(mean([tblrdmdz.myaucresid1,tblrdmdz.myaucresid2],2), tbltwinsdz.myaucresidhigh, [mean([tblrdmdz.accuracy1,tblrdmdz.accuracy2],2), tbltwinsdz.accuracy])
[rho, pval] = partialcorr(mean([tblrdmdz.myaucresid1,tblrdmdz.myaucresid2],2), tblstrangersdz.myaucresidhigh, [mean([tblrdmdz.accuracy1,tblrdmdz.accuracy2],2), tblstrangersdz.accuracy])

%%

txt = sprintf('MZ自评和评价twins时resid AUC的关系');
tmp = [mean([tblrdmmz.myaucresid1,tblrdmmz.myaucresid2],2), tbltwinsmz.myaucresidhigh];
voi = [tmp(1:2:end,1), tmp(2:2:end,1), tmp(1:2:end,2), tmp(2:2:end,2)];
figure;
for ii = 1:length(voi)
    plot(voi(ii,[1,2]), voi(ii,[3,4]), '*-')
    hold on
end
xlabel('self rdm auc');ylabel('self guess auc');
title(txt)

mentalizingdz = [pdist2([voi(:,1), voi(:,3)], [1,1], 'cosine'), pdist2([voi(:,2), voi(:,4)], [1,1], 'cosine')];

%% could be del
mzmental3d = [voi, (1:length(voi))'];
mzmental3d = array2table(mzmental3d, ...
    'VariableNames',{'selfrdmauc1', 'selfrdmauc2', 'selfguessauc1', 'selfguessauc2', 'twinNum'});

figure;
for ii = 1:height(mzmental3d)
plot3([mzmental3d.selfrdmauc1(ii), mzmental3d.selfguessauc1(ii), mzmental3d.twinNum(ii)], [mzmental3d.selfrdmauc2(ii), mzmental3d.selfguessauc2(ii), mzmental3d.twinNum(ii)],'o-')
hold on 
% plot3(mzmental3d.selfrdmauc2, mzmental3d.selfguessauc2, mzmental3d.twinNum)
% hold off
end
xlabel('self rdm auc');ylabel('self guess auc');zlabel('twinsNum');


%% cross-correlation
tmp = [mean([tblrdmmz.myauc1,tblrdmmz.myauc2],2), tbltwinsmz.myauc];
mzmental3d = [tmp(1:2:end,1), tmp(2:2:end,1), tmp(1:2:end,2), tmp(2:2:end,2)];
mzmental3d = array2table(mzmental3d, ...
    'VariableNames',{'selfrdmauc1', 'selfrdmauc2', 'selfguessauc1', 'selfguessauc2'});

tmp = [mean([tblrdmdz.myauc1,tblrdmdz.myauc2],2), tbltwinsdz.myauc];
dzmental3d = [tmp(1:2:end,1), tmp(2:2:end,1), tmp(1:2:end,2), tmp(2:2:end,2)];
dzmental3d = array2table(dzmental3d, ...
    'VariableNames',{'selfrdmauc1', 'selfrdmauc2', 'selfguessauc1', 'selfguessauc2'});

%%% random half sample
% totalmentala = [[mzmental3d.selfrdmauc1;dzmental3d.selfrdmauc1], [mzmental3d.selfguessauc2, dzmental3d.selfguessauc2]]; % [rdmauc1, guessauc2]
% totalmentalb = [[mzmental3d.selfrdmauc2;dzmental3d.selfrdmauc2], [dzmental3d.selfguessauc1, dzmental3d.selfguessauc1]]; % [rdmauc2, guessauc1]
% phenocorr = [1, corr2(mzmental3d);]

TwinsBS_ICC([tbltwinsmz.myaucresidhigh(1:2:end), tbltwinsmz.myaucresidhigh(2:2:end)],0,'MZ Guess twins AUC resid');
TwinsBS_ICC([tbltwinsdz.myaucresidhigh(1:2:end), tbltwinsdz.myaucresidhigh(2:2:end)],0,'DZ Guess twins AUC resid');
TwinsBS_ICC([tblstrangersmz.myaucresidhigh(1:2:end), tblstrangersmz.myaucresidhigh(2:2:end)],0,'MZ Guess strangers AUC resid');
TwinsBS_ICC([tblstrangersdz.myaucresidhigh(1:2:end), tblstrangersdz.myaucresidhigh(2:2:end)],0,'DZ Guess strangers AUC resid');

TwinsBS_ICC([mean([tblrdmmz.myaucresid1(1:2:end), tblrdmmz.myaucresid2(1:2:end)],2), mean([tblrdmmz.myaucresid1(2:2:end), tblrdmmz.myaucresid2(2:2:end)],2)], 0,'MZ RDM AUC resid');
TwinsBS_ICC([mean([tblrdmdz.myaucresid1(1:2:end), tblrdmdz.myaucresid2(1:2:end)],2), mean([tblrdmdz.myaucresid1(2:2:end), tblrdmdz.myaucresid2(2:2:end)],2)], 0,'DZ RDM AUC resid');

figure;
PlotIntraClass(log([tbltwinsmz.myauc(1:2:end), tbltwinsmz.myauc(2:2:end)]),'1-1','MZ Guess AUC raw');
figure;
PlotIntraClass(log([tbltwinsdz.myauc(1:2:end), tbltwinsdz.myauc(2:2:end)]),'1-1','DZ Guess AUC raw');
figure;
PlotIntraClass(log([tbltwinsmz.myaucresidhigh(1:2:end), tbltwinsmz.myaucresidhigh(2:2:end)]),'1-1','MZ Guess AUC resid');
figure;
PlotIntraClass(log([tbltwinsdz.myaucresidhigh(1:2:end), tbltwinsdz.myaucresidhigh(2:2:end)]),'1-1','DZ Guess AUC resid');

%% metacognition and mentalizing correlation permutation
tbltwinmentalizing = readtable('result_files\TwinMental0704-17;57;19.csv');
tblstrangermentalizing = readtable('result_files\StrangerMental0704-17;57;19.csv');

% raw resid auc correlation in MZ and DZ
mz = tbltwinmentalizing.zyg==1;
dz = ~mz;
mztwinmental = [[tbltwinmentalizing.selfrdmaucresid1(mz), tbltwinmentalizing.selfguessaucresid1(mz)];...
    [tbltwinmentalizing.selfrdmaucresid2(mz), tbltwinmentalizing.selfguessaucresid2(mz)]]; % [selfrdmaucresid, selfguessaucresid]
dztwinmental = [[tbltwinmentalizing.selfrdmaucresid1(dz), tbltwinmentalizing.selfguessaucresid1(dz)];...
    [tbltwinmentalizing.selfrdmaucresid2(dz), tbltwinmentalizing.selfguessaucresid2(dz)]];

mz = tblstrangermentalizing.zyg==1;
dz = ~mz;
mzstrangermental = [[tblstrangermentalizing.selfrdmaucresid1(mz), tblstrangermentalizing.selfguessaucresid1(mz)];...
    [tblstrangermentalizing.selfrdmaucresid2(mz), tblstrangermentalizing.selfguessaucresid2(mz)]];
dzstrangermental = [[tblstrangermentalizing.selfrdmaucresid1(dz), tblstrangermentalizing.selfguessaucresid1(dz)];...
    [tblstrangermentalizing.selfrdmaucresid2(dz), tblstrangermentalizing.selfguessaucresid2(dz)]];

mztwinauccorr = corr(mztwinmental);
dztwinauccorr = corr(dztwinmental);
corrdiff = mztwinauccorr(1,2)-dztwinauccorr(1,2);
% resid auc correlation permutation test
totalmental = [mztwinmental; dztwinmental];
nsamplea = length(mztwinmental);
nsampleb = length(dztwinmental);
times = 1e5;
for ii = 1:times
    rdseed = randperm(length(totalmental));
    tmpmental = totalmental(rdseed, :);
    
    parta = tmpmental(1:nsamplea, :);
    partb = tmpmental(nsamplea+1:end,:);
    partacorr = corr(parta);
    partbcorr = corr(partb);
    
    permcorrdiff(ii) = partacorr(1,2) - partbcorr(1,2);
    
end

% figure plot
figure;
histogram(permcorrdiff)
hold on
plot([corrdiff, corrdiff], [0,1000], 'r')
permp = mean(permcorrdiff>corrdiff);
tmptxt = sprintf('self rdm and guess resid auc correlation different permutation test \np=%.3f', permp);
title(num2str(tmptxt))


%% Calculate Cronbach's alpha !!!wrong!!!
% ICC(x, 'C-k')
% rtweight, iscgamma, auc, aucresid
% 
atmp = [-1*twinsrtweightmz(:), twinsmyiscgammamz(:), twinsmyiscgammahighmz(:), twinsaucrawmz(:)]; %
btmp = [-1*twinsrtweightdz(:), twinsmyiscgammadz(:), twinsmyiscgammahighdz(:), twinsaucrawdz(:)]; %
ICC(atmp, 'C-k')
ICC(btmp, 'C-k')

% ICC([twinsaucrawmz(:), twinsaucresidmz(:)], 'C-k')
% ICC([twinsaucrawdz(:), twinsaucresiddz(:)], 'C-k')
% ICC([twinsmyiscgammamz(:), twinsmyiscgammahighmz(:)], 'C-k')
% ICC([twinsmyiscgammadz(:), twinsmyiscgammahighdz(:)], 'C-k')

times = 1e5;
allalphamz = [];
allalphadz = [];
nmz = length(twinsaucrawmz);
nsample = floor(nmz*0.75);
for ii = times:-1:1
    idx = randperm(nmz, nsample);
    tmpa = twinsrtweightmz(idx, :);
    tmpb = twinsmyiscgammamz(idx, :);
    tmpc = twinsmyiscgammahighmz(idx, :);
    tmpd = twinsaucrawmz(idx, :);
%     tmpe = twinsaucresidmz(idx, :);
    atmp = [-1*tmpa(:), tmpb(:), tmpc(:), tmpd(:)]; %
    
    allalphamz(ii,1) = ICC(atmp, 'C-k');


end

ndz = length(twinsaucrawdz);
nsample = floor(ndz*0.75);
for ii = times:-1:1
    idx = randperm(ndz, nsample);
    tmpa = twinsrtweightdz(idx, :);
    tmpb = twinsmyiscgammadz(idx, :);
    tmpc = twinsmyiscgammahighdz(idx, :);
    tmpd = twinsaucrawdz(idx, :);
%     tmpe = twinsaucresiddz(idx, :);
    atmp = [-1*tmpa(:), tmpb(:), tmpc(:), tmpd(:)]; %
    
    allalphadz(ii,1) = ICC(atmp, 'C-k');

end

figure;histogram(allalphamz)
title('MZ')
figure;histogram(allalphadz)
title('DZ')

%%%%%%%%%%%%%%%%%%%%
colormds = [lines(2); 0.5,0.5,0.5];
figure;
h = histogram(allalphamz,100,  'EdgeColor','none', 'FaceColor',colormds(1,:),'Normalization','probability');
hold on; 
h = histogram(allalphadz,100 ,'EdgeColor','none', 'FaceColor',colormds(2,:),'Normalization','probability');
box off
xlim([0.4,0.8]);ylim([0,0.04])
set(gca,'YTick',0:0.01:0.04, 'XTick', 0.4:0.1:0.8, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})



%%
[~,p(1),zstat(1)] = Ztest_std(icc_mztwins_rtweight, icc_mztwins_randperm_rtweight);
[~,p(2),zstat(2)] = Ztest_std(icc_mzstranger_rtweight, icc_mzstranger_randperm_rtweight);
[~,p(3),zstat(3)] = Ztest_std(icc_dztwins_rtweight, icc_dztwins_randperm_rtweight);
[~,p(4),zstat(4)] = Ztest_std(icc_dzstranger_rtweight, icc_dzstranger_randperm_rtweight);
[~,p(5),zstat(5)] = Ztest_std(icc_mztwins_rtweight, icc_dztwins_rtweight);
[~,p(6),zstat(6)] = Ztest_std(icc_mzstranger_rtweight, icc_dzstranger_rtweight);
[p', zstat']
clear p zstat
[~,p(1),zstat(1)] = Ztest_std(icc_mztwins_rtweight, 0);
[~,p(2),zstat(2)] = Ztest_std(icc_mzstranger_rtweight, 0);
[~,p(3),zstat(3)] = Ztest_std(icc_dztwins_rtweight, 0);
[~,p(4),zstat(4)] = Ztest_std(icc_dzstranger_rtweight, 0);
[p', zstat']
%%%%%%%%%%%%%%%%%%%%%%%%
[~,p(1),zstat(1)] = Ztest_std(icc_mztwins_myiscgamma, icc_mztwins_randperm_myiscgamma);
[~,p(2),zstat(2)] = Ztest_std(icc_mzstranger_myiscgamma, icc_mzstranger_randperm_myiscgamma);
[~,p(3),zstat(3)] = Ztest_std(icc_dztwins_myiscgamma, icc_dztwins_randperm_myiscgamma);
[~,p(4),zstat(4)] = Ztest_std(icc_dzstranger_myiscgamma, icc_dzstranger_randperm_myiscgamma);
[~,p(5),zstat(5)] = Ztest_std(icc_mztwins_myiscgamma, icc_dztwins_myiscgamma);
[~,p(6),zstat(6)] = Ztest_std(icc_mzstranger_myiscgamma, icc_dzstranger_myiscgamma);
[p', zstat']
clear p zstat
[~,p(1),zstat(1)] = Ztest_std(icc_mztwins_myiscgamma, 0);
[~,p(2),zstat(2)] = Ztest_std(icc_mzstranger_myiscgamma, 0);
[~,p(3),zstat(3)] = Ztest_std(icc_dztwins_myiscgamma, 0);
[~,p(4),zstat(4)] = Ztest_std(icc_dzstranger_myiscgamma, 0);
[p', zstat']
%%%%%%%%%%%%%%%%%%%%%%%%
[~,p(1),zstat(1)] = Ztest_std(icc_mztwins_mentalraw, icc_mztwins_randperm_mentalraw);
[~,p(2),zstat(2)] = Ztest_std(icc_mzstranger_mentalraw, icc_mzstranger_randperm_mentalraw);
[~,p(3),zstat(3)] = Ztest_std(icc_dztwins_mentalraw, icc_dztwins_randperm_mentalraw);
[~,p(4),zstat(4)] = Ztest_std(icc_dzstranger_mentalraw, icc_dzstranger_randperm_mentalraw);
[~,p(5),zstat(5)] = Ztest_std(icc_mztwins_mentalraw, icc_dztwins_mentalraw);
[~,p(6),zstat(6)] = Ztest_std(icc_mzstranger_mentalraw, icc_dzstranger_mentalraw);
[p', zstat']
clear p zstat
[~,p(1),zstat(1)] = Ztest_std(icc_mztwins_mentalraw, 0);
[~,p(2),zstat(2)] = Ztest_std(icc_mzstranger_mentalraw, 0);
[~,p(3),zstat(3)] = Ztest_std(icc_dztwins_mentalraw, 0);
[~,p(4),zstat(4)] = Ztest_std(icc_dzstranger_mentalraw, 0);
[p', zstat']
%%%%%%%%%%%%%%%%%%%%%%%%
[~,p(1),zstat(1)] = Ztest_std(icc_mztwins_mental, icc_mztwins_randperm_mental);
[~,p(2),zstat(2)] = Ztest_std(icc_mzstranger_mental, icc_mzstranger_randperm_mental);
[~,p(3),zstat(3)] = Ztest_std(icc_dztwins_mental, icc_dztwins_randperm_mental);
[~,p(4),zstat(4)] = Ztest_std(icc_dzstranger_mental, icc_dzstranger_randperm_mental);
[~,p(5),zstat(5)] = Ztest_std(icc_mztwins_mental, icc_dztwins_mental);
[~,p(6),zstat(6)] = Ztest_std(icc_mzstranger_mental, icc_dzstranger_mental);
[p', zstat']
clear p zstat
[~,p(1),zstat(1)] = Ztest_std(icc_mztwins_mental, 0);
[~,p(2),zstat(2)] = Ztest_std(icc_mzstranger_mental, 0);
[~,p(3),zstat(3)] = Ztest_std(icc_dztwins_mental, 0);
[~,p(4),zstat(4)] = Ztest_std(icc_dzstranger_mental, 0);
[p', zstat']
%%%%%%%%%%%%%%%%%%%%%%%%
[~,p(1),zstat(1)] = Ztest_std(icc_mztwins_myiscgammahigh, icc_mztwins_randperm_myiscgammahigh);
[~,p(2),zstat(2)] = Ztest_std(icc_mzstranger_myiscgammahigh, icc_mzstranger_randperm_myiscgammahigh);
[~,p(3),zstat(3)] = Ztest_std(icc_dztwins_myiscgammahigh, icc_dztwins_randperm_myiscgammahigh);
[~,p(4),zstat(4)] = Ztest_std(icc_dzstranger_myiscgammahigh, icc_dzstranger_randperm_myiscgammahigh);
[~,p(5),zstat(5)] = Ztest_std(icc_mztwins_myiscgammahigh, icc_dztwins_myiscgammahigh);
[~,p(6),zstat(6)] = Ztest_std(icc_mzstranger_myiscgammahigh, icc_dzstranger_myiscgammahigh);
[p', zstat']
clear p zstat
[~,p(1),zstat(1)] = Ztest_std(icc_mztwins_myiscgammahigh, 0);
[~,p(2),zstat(2)] = Ztest_std(icc_mzstranger_myiscgammahigh, 0);
[~,p(3),zstat(3)] = Ztest_std(icc_dztwins_myiscgammahigh, 0);
[~,p(4),zstat(4)] = Ztest_std(icc_dzstranger_myiscgammahigh, 0);
[p', zstat']

%% crobach alpha
% btmp = {tbltwinsmz.confcorrraw, tblstrangersmz.confcorrraw, tbltwinsdz.confcorrraw, tblstrangersdz.confcorrraw};
% btmp = {tbltwinsmz.confcorr_residhigh, tblstrangersmz.confcorr_residhigh, tbltwinsdz.confcorr_residhigh, tblstrangersdz.confcorr_residhigh};
% btmp = {tbltwinsmz.myauc, tblstrangersmz.myauc, tbltwinsdz.myauc, tblstrangersdz.myauc};
% btmp = {tbltwinsmz.myiscgamma, tblstrangersmz.myiscgamma, tbltwinsdz.myiscgamma, tblstrangersdz.myiscgamma};

atmp = [tbltwinsmz.confcorrraw, tbltwinsmz.myauc, tbltwinsmz.myiscgamma]; %
btmp = [tblstrangersmz.confcorrraw, tblstrangersmz.myauc, tblstrangersmz.myiscgamma]; %
ctmp = [tbltwinsdz.confcorrraw, tbltwinsdz.myauc, tbltwinsdz.myiscgamma]; %
dtmp = [tblstrangersdz.confcorrraw, tblstrangersdz.myauc, tblstrangersdz.myiscgamma]; %
ICC(atmp, 'C-k')
ICC(btmp, 'C-k')
ICC(ctmp, 'C-k')
ICC(dtmp, 'C-k')

times = 1e5;
allalpha = [];
% nmz = length(atmp);
% nsample = floor(nmz*0.75);
tic;
for ii = times:-1:1
    idx = randperm(length(atmp), floor(length(atmp)*0.75));
    thistmpa = atmp(idx,:); %
    idx = randperm(length(btmp), floor(length(btmp)*0.75));
    thistmpb = btmp(idx,:); %
    idx = randperm(length(ctmp), floor(length(ctmp)*0.75));
    thistmpc = ctmp(idx,:); %
    idx = randperm(length(dtmp), floor(length(dtmp)*0.75));
    thistmpd = dtmp(idx,:); %
    
    allalpha(ii,1) = ICC(thistmpa, 'C-k');
    allalpha(ii,2) = ICC(thistmpb, 'C-k');
    allalpha(ii,3) = ICC(thistmpc, 'C-k');
    allalpha(ii,4) = ICC(thistmpd, 'C-k');
end
toc();
alphatwinsmz_3raw = allalpha(:,1);
alphastrangersmz_3raw = allalpha(:,2);
alphatwinsdz_3raw = allalpha(:,3);
alphastrangersdz_3raw = allalpha(:,4);

atmp = [tbltwinsmz.confcorr_residhigh, tbltwinsmz.myaucresidhigh, tbltwinsmz.myiscgammahigh]; %
btmp = [tblstrangersmz.confcorr_residhigh, tblstrangersmz.myaucresidhigh, tblstrangersmz.myiscgammahigh]; %
ctmp = [tbltwinsdz.confcorr_residhigh, tbltwinsdz.myaucresidhigh, tbltwinsdz.myiscgammahigh]; %
dtmp = [tblstrangersdz.confcorr_residhigh, tblstrangersdz.myaucresidhigh, tblstrangersdz.myiscgammahigh]; %
ICC(atmp, 'C-k')
ICC(btmp, 'C-k')
ICC(ctmp, 'C-k')
ICC(dtmp, 'C-k')

times = 1e5;
allalpha = [];
% nmz = length(atmp);
% nsample = floor(nmz*0.75);
tic;
for ii = times:-1:1
    idx = randperm(length(atmp), floor(length(atmp)*0.75));
    thistmpa = atmp(idx,:); %
    idx = randperm(length(btmp), floor(length(btmp)*0.75));
    thistmpb = btmp(idx,:); %
    idx = randperm(length(ctmp), floor(length(ctmp)*0.75));
    thistmpc = ctmp(idx,:); %
    idx = randperm(length(dtmp), floor(length(dtmp)*0.75));
    thistmpd = dtmp(idx,:); %
    
    allalpha(ii,1) = ICC(thistmpa, 'C-k');
    allalpha(ii,2) = ICC(thistmpb, 'C-k');
    allalpha(ii,3) = ICC(thistmpc, 'C-k');
    allalpha(ii,4) = ICC(thistmpd, 'C-k');
end
toc();
alphatwinsmz_3resid = allalpha(:,1);
alphastrangersmz_3resid = allalpha(:,2);
alphatwinsdz_3resid = allalpha(:,3);
alphastrangersdz_3resid = allalpha(:,4);

