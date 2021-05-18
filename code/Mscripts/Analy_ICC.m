%% For RDM permutation test between sessions
clear; 
home
st = tic;
%% read data
tblraw = readtable('result_files/RDM2sessions1113-15;42;45.csv', 'FileType','text');
% tblraw = readtable('result0307-13;56;44.xlsx', 'FileType','spreadsheet');
%% exclude data
tbl = tblraw;

%%%%%
% overlap = {'T001','T007','T013','T028','T033','T035','T054','T055','T087','T088','T090'};
% rmaucresid = {'T028','T001','T113','T007','T055','T084','T124','T090','T087','T033'};
% rmaucraw = {'T028','T001','T090','T055','T087','T007','T035','T053','T013','T054'};
% eraseDZ = FindStrinCell('T006', tbl.twinsNum); % missing 50 trials in one session
eraseDZ = [];
eraseMZ = FindStrinCell({'T001','T007','T013','T028','T033','T035','T054','T055','T087','T088','T090'}, ... % max ten pairs of MZ auc difference
    tbl.twinsNum);
tblerased = tbl(eraseMZ, :);
tbl([eraseMZ; eraseDZ], :) = [];
%%%%%

tblmz = tbl(tbl.zyg==1,:);
tbldz = tbl(tbl.zyg==2,:);
% tbl = sortrows(tbl, {'daytime','othername'}); % sort rdm task names within same daytime

%%
colorms = [1,0,0; 0.5,0.5,0.5];
colords = [0,1,0; 0.5,0.5,0.5];
colormd = [1,0,0; 0,1,0];

subinfo = [tbl.zyg(1:2:end), tbl.ismale(1:2:end), tbl.age(1:2:end)]; %tbl.daytime(1:2:end), tbl.twinsNum(1:2:end),
mcoh = [tbl.mcoh(1:2:end), tbl.mcoh(2:2:end)]; %[twinA, twinB]
auc = [tbl.myauc1(1:2:end), tbl.myauc2(1:2:end), tbl.myauc1(2:2:end), tbl.myauc2(2:2:end)]; %[twinA1, twinA2, twinB1, twinB2]
accu = [tbl.accuracy1(1:2:end), tbl.accuracy2(1:2:end), tbl.accuracy1(2:2:end), tbl.accuracy2(2:2:end)];
aucresid = [tbl.myaucresid1(1:2:end), tbl.myaucresid2(1:2:end), tbl.myaucresid1(2:2:end), tbl.myaucresid2(2:2:end)];
mrtime =  [tbl.mrtime1(1:2:end), tbl.mrtime2(1:2:end), tbl.mrtime1(2:2:end), tbl.mrtime2(2:2:end)];
myrtcorr =  [tbl.myrtcorr1(1:2:end), tbl.myrtcorr2(1:2:end), tbl.myrtcorr1(2:2:end), tbl.myrtcorr2(2:2:end)];
myiscgamma =  [tbl.myiscgamma1(1:2:end), tbl.myiscgamma2(1:2:end), tbl.myiscgamma1(2:2:end), tbl.myiscgamma2(2:2:end)];
stdrtime = [tbl.stdrtime1(1:2:end), tbl.stdrtime2(1:2:end), tbl.stdrtime1(2:2:end), tbl.stdrtime2(2:2:end)];
mconf = [tbl.mconf1(1:2:end), tbl.mconf2(1:2:end), tbl.mconf1(2:2:end), tbl.mconf2(2:2:end)];

%% self test retest for bootstrap [subtest, subretest]
self_accu = [tbl.accuracy1, tbl.accuracy2];
% self_mrtime = [RDMsub1(1:2:end, 3), RDMsub1(2:2:end, 3); RDMsub2(1:2:end, 3), RDMsub2(2:2:end, 3)];
% self_rtconf = [RDMsub1(1:2:end, 4), RDMsub1(2:2:end, 4); RDMsub2(1:2:end, 4), RDMsub2(2:2:end, 4)];
self_auc = [tbl.myauc1, tbl.myauc2];
self_mrtime = [tbl.mrtime1, tbl.mrtime2];
self_stdrtime = [tbl.stdrtime1, tbl.stdrtime2];
self_mconf = [tbl.mconf1, tbl.mconf2];

%%% self test retest permutation
%TODO
corr_self_auc = SelfBS(self_auc, 'self random auc test-retest correlation');
% xlim([0,1])
corr_self_accu = SelfBS(self_accu, 'self random accu test-retest correlation');
% xlim([0,1])
corr_self_mrtime = SelfBS(self_mrtime, 'self random mrtime test-retest correlation');
corr_self_stdrtime = SelfBS(self_stdrtime, 'self random stdrtime test-retest correlation');
corr_self_mconf = SelfBS(self_mconf, 'self random mconf test-retest correlation');

%%
self_accu_mz = [tbl.accuracy1(tbl.zyg==1), tbl.accuracy2(tbl.zyg==1)];
self_accu_dz = [tbl.accuracy1(tbl.zyg==2), tbl.accuracy2(tbl.zyg==2)];
self_auc_mz = [tbl.myauc1(tbl.zyg==1), tbl.myauc2(tbl.zyg==1)];
self_auc_dz = [tbl.myauc1(tbl.zyg==2), tbl.myauc2(tbl.zyg==2)];
self_mrtime_mz = [tbl.mrtime1(tbl.zyg==1), tbl.mrtime2(tbl.zyg==1)];
self_mrtime_dz = [tbl.mrtime1(tbl.zyg==2), tbl.mrtime2(tbl.zyg==2)];
self_stdrtime_mz = [tbl.stdrtime1(tbl.zyg==1), tbl.stdrtime2(tbl.zyg==1)];
self_stdrtime_dz = [tbl.stdrtime1(tbl.zyg==2), tbl.stdrtime2(tbl.zyg==2)];
self_mconf_mz = [tbl.mconf1(tbl.zyg==1), tbl.mconf2(tbl.zyg==1)];
self_mconf_dz = [tbl.mconf1(tbl.zyg==2), tbl.mconf2(tbl.zyg==2)];
self_myrtcorr_mz = [tbl.myrtcorr1(tbl.zyg==1), tbl.myrtcorr2(tbl.zyg==1)];
self_myrtcorr_dz = [tbl.myrtcorr1(tbl.zyg==2), tbl.myrtcorr2(tbl.zyg==2)];
self_myiscgamma_mz = [tbl.myiscgamma1(tbl.zyg==1), tbl.myiscgamma2(tbl.zyg==1)];
self_myiscgamma_dz = [tbl.myiscgamma1(tbl.zyg==2), tbl.myiscgamma2(tbl.zyg==2)];

%%% self test retest permutation
%TODO
corr_self_aucmz = SelfBS(self_auc_mz, 'self random auc test-retest correlation');
corr_self_aucdz = SelfBS(self_auc_dz, 'self random auc test-retest correlation');
% xlim([0,1])
corr_self_accumz = SelfBS(self_accu_mz, 'self random accu test-retest correlation');
corr_self_accudz = SelfBS(self_accu_dz, 'self random accu test-retest correlation');
% xlim([0,1])
corr_self_mrtimemz = SelfBS(self_mrtime_mz, 'self random mrtime test-retest correlation');
corr_self_mrtimedz = SelfBS(self_mrtime_dz, 'self random mrtime test-retest correlation');
%
corr_self_stdrtimemz = SelfBS(self_stdrtime_mz, 'self random stdrtime test-retest correlation');
corr_self_stdrtimedz = SelfBS(self_stdrtime_dz, 'self random stdrtime test-retest correlation');
%
corr_self_mconfmz = SelfBS(self_mconf_mz, 'self random mconf test-retest correlation');
corr_self_mconfdz = SelfBS(self_mconf_dz, 'self random mconf test-retest correlation');
%
corr_self_myrtcorrmz = SelfBS(self_myrtcorr_mz, 'self random mconf test-retest correlation');
corr_self_myrtcorrdz = SelfBS(self_myrtcorr_dz, 'self random mconf test-retest correlation');
%
corr_self_myiscgammamz = SelfBS(self_myiscgamma_mz, 'self random iscgamma test-retest correlation');
corr_self_myiscgammadz = SelfBS(self_myiscgamma_dz, 'self random iscgamma test-retest correlation');

%% pair correlation [sub1test, sub1retest, sub2test, sub2retest]
twins_mcoh = [subinfo, mcoh];
twins_accu = [subinfo, accu];
% twins_mrtime = [subinfo, mrtime];
% twins_rtcorr = [RDMsub1(1:2:end, 4), RDMsub1(2:2:end, 4), RDMsub2(1:2:end, 4), RDMsub2(2:2:end, 4), RDMsub1(1:2:end, 7), RDMsub1(1:2:end, 8)];
twins_auc = [subinfo, auc];
twins_aucresid = [subinfo, aucresid];
twins_mrtime = [subinfo, mrtime];
twins_myrtcorr = [subinfo, myrtcorr];
twins_myiscgamma = [subinfo, myiscgamma];
twins_stdrtime = [subinfo, stdrtime];
twins_mconf = [subinfo, mconf];

%
twinsmz_auc = twins_auc(subinfo(:,1)==1, end-3:end);
twinsdz_auc = twins_auc(subinfo(:,1)==2, end-3:end);
twinsmz_aucresid = twins_aucresid(subinfo(:,1)==1, end-3:end);
twinsdz_aucresid = twins_aucresid(subinfo(:,1)==2, end-3:end);
twinsmz_accu = twins_accu(subinfo(:,1)==1, end-3:end);
twinsdz_accu = twins_accu(subinfo(:,1)==2, end-3:end);
twinsmz_mconf = twins_mconf(subinfo(:,1)==1, end-3:end);
twinsdz_mconf = twins_mconf(subinfo(:,1)==2, end-3:end);
twinsmz_mcoh = twins_mcoh(subinfo(:,1)==1, end-1:end);
twinsdz_mcoh = twins_mcoh(subinfo(:,1)==2, end-1:end);
twinsmz_mrtime = twins_mrtime(subinfo(:,1)==1, end-3:end);
twinsdz_mrtime = twins_mrtime(subinfo(:,1)==2, end-3:end);
twinsmz_stdrtime = twins_stdrtime(subinfo(:,1)==1, end-3:end);
twinsdz_stdrtime = twins_stdrtime(subinfo(:,1)==2, end-3:end);
twinsmz_myrtcorr = twins_myrtcorr(subinfo(:,1)==1, end-3:end);
twinsdz_myrtcorr = twins_myrtcorr(subinfo(:,1)==2, end-3:end);
twinsmz_myiscgamma = twins_myiscgamma(subinfo(:,1)==1, end-3:end);
twinsdz_myiscgamma = twins_myiscgamma(subinfo(:,1)==2, end-3:end);
% twinsdz2session_auc = [mean(twinsdz_auc(:,[1,2]),2),mean(twinsdz_auc(:,[3,4]),2)] ;
% twinsdz2session_accu = [mean(twinsdz_accu(:,[1,2]),2),mean(twinsdz_accu(:,[3,4]),2)] ;
% twinsmz2session_auc = [mean(twinsmz_auc(:,[1,2]),2),mean(twinsmz_auc(:,[3,4]),2)] ;
% twinsmz2session_accu = [mean(twinsmz_accu(:,[1,2]),2),mean(twinsmz_accu(:,[3,4]),2)] ;

%% twins order permutation
% corr_order_mcoh = TwinsBootstrap(twins_mcoh,0,'mcoh order permutation');
% icc_order_mcoh = TwinsBootstrap(twins_mcoh,0,'mcoh order permutation');

%%

%%


%%% twins permutation
% voi = twins_auc;
% icc_twins_auc = TwinsBS_ICC(voi, 0, 'twins random auc pair correlation');
% icc_stranger_auc = TwinsBS_ICC(voi, 1, 'twins random auc stranger pair correlation');

%
icc_mztwins_auc = TwinsBS_ICC(twinsmz_auc, 0);
icc_dztwins_auc = TwinsBS_ICC(twinsdz_auc, 0);
icc_mzstranger_auc = TwinsBS_ICC(twinsmz_auc, 1);
icc_dzstranger_auc = TwinsBS_ICC(twinsdz_auc, 1);
figure;
PlotHistograms(icc_mztwins_auc, icc_mzstranger_auc, 'MZ AUC Bootstrap',colorms)
legend('twin','stranger')
figure;
PlotHistograms(icc_dztwins_auc, icc_dzstranger_auc, 'DZ AUC Bootstrap',colords)
legend('twin','stranger')
figure;
PlotHistograms(icc_mztwins_auc, icc_dztwins_auc, 'AUC MZ DZ Bootstrap',colormd)
legend('MZ','DZ')

%
icc_mztwins_aucresid = TwinsBS_ICC(twinsmz_aucresid, 0);
icc_dztwins_aucresid = TwinsBS_ICC(twinsdz_aucresid, 0);
icc_mzstranger_aucresid = TwinsBS_ICC(twinsmz_aucresid, 1);
icc_dzstranger_aucresid = TwinsBS_ICC(twinsdz_aucresid, 1);
figure;
PlotHistograms(icc_mztwins_aucresid, icc_mzstranger_aucresid, 'MZ AUCresid Bootstrap',colorms)
legend('twin','stranger')
figure;
PlotHistograms(icc_dztwins_aucresid, icc_dzstranger_aucresid, 'DZ AUCresid Bootstrap',colords)
legend('twin','stranger')
figure;
PlotHistograms(icc_mztwins_aucresid, icc_dztwins_aucresid, 'AUCresid MZ DZ Bootstrap',colormd)
legend('MZ','DZ')

%
icc_mztwins_accu = TwinsBS_ICC(twinsmz_accu, 0);
icc_dztwins_accu = TwinsBS_ICC(twinsdz_accu, 0);
icc_mzstranger_accu = TwinsBS_ICC(twinsmz_accu, 1);
icc_dzstranger_accu = TwinsBS_ICC(twinsdz_accu, 1);

figure;
PlotHistograms(icc_mztwins_accu, icc_mzstranger_accu, 'MZ Accuracy Bootstrap',colorms)
legend('twin','stranger')
figure;
PlotHistograms(icc_dztwins_accu, icc_dzstranger_accu, 'DZ Accuracy Bootstrap',colords)
legend('twin','stranger')
figure;
PlotHistograms(icc_mztwins_accu, icc_dztwins_accu, 'Accuracy MZ DZ Bootstrap',colormd)
legend('MZ','DZ')

%
icc_mztwins_mcoh = TwinsBS_ICC(twinsmz_mcoh, 0);
icc_dztwins_mcoh = TwinsBS_ICC(twinsdz_mcoh, 0);
icc_mzstranger_mcoh = TwinsBS_ICC(twinsmz_mcoh, 1);
icc_dzstranger_mcoh = TwinsBS_ICC(twinsdz_mcoh, 1);
figure;
PlotHistograms(icc_mztwins_mcoh, icc_mzstranger_mcoh, 'MZ Coherence Bootstrap',colorms)
legend('twin','stranger')
figure;
PlotHistograms(icc_dztwins_mcoh, icc_dzstranger_mcoh, 'DZ Coherence Bootstrap',colords)
legend('twin','stranger')
figure;
PlotHistograms(icc_mztwins_mcoh, icc_dztwins_mcoh, 'Coherence MZ DZ Bootstrap',colormd)
legend('MZ','DZ')

%
icc_mztwins_mrtime = TwinsBS_ICC(twinsmz_mrtime, 0);
icc_dztwins_mrtime = TwinsBS_ICC(twinsdz_mrtime, 0);
icc_mzstranger_mrtime = TwinsBS_ICC(twinsmz_mrtime, 1);
icc_dzstranger_mrtime = TwinsBS_ICC(twinsdz_mrtime, 1);
figure;
PlotHistograms(icc_mztwins_mrtime, icc_mzstranger_mrtime, 'MZ meanRT Bootstrap',colorms)
legend('twin','stranger')
figure;
PlotHistograms(icc_dztwins_mrtime, icc_dzstranger_mrtime, 'DZ meanRT Bootstrap',colords)
legend('twin','stranger')
figure;
PlotHistograms(icc_mztwins_mrtime, icc_dztwins_mrtime, 'meanRT MZ DZ Bootstrap',colormd)
legend('MZ','DZ')

%
icc_mztwins_myrtcorr = TwinsBS_ICC(twinsmz_myrtcorr, 0);
icc_dztwins_myrtcorr = TwinsBS_ICC(twinsdz_myrtcorr, 0);
icc_mzstranger_myrtcorr = TwinsBS_ICC(twinsmz_myrtcorr, 1);
icc_dzstranger_myrtcorr = TwinsBS_ICC(twinsdz_myrtcorr, 1);
figure;
PlotHistograms(icc_mztwins_myrtcorr, icc_mzstranger_myrtcorr, 'MZ rtconf\_corr Bootstrap',colorms)
legend('twin','stranger')
figure;
PlotHistograms(icc_dztwins_myrtcorr, icc_dzstranger_myrtcorr, 'DZ rtconf\_corr Bootstrap',colords)
legend('twin','stranger')
figure;
PlotHistograms(icc_mztwins_myrtcorr, icc_dztwins_myrtcorr, 'rtconf\_corr MZ DZ Bootstrap',colormd)
legend('MZ','DZ')

%
icc_mztwins_myiscgamma = TwinsBS_ICC(twinsmz_myiscgamma, 0);
icc_dztwins_myiscgamma = TwinsBS_ICC(twinsdz_myiscgamma, 0);
icc_mzstranger_myiscgamma = TwinsBS_ICC(twinsmz_myiscgamma, 1);
icc_dzstranger_myiscgamma = TwinsBS_ICC(twinsdz_myiscgamma, 1);
figure;
PlotHistograms(icc_mztwins_myiscgamma, icc_mzstranger_myiscgamma, 'MZ rtconf\_corr Bootstrap',colorms)
legend('twin','stranger')
figure;
PlotHistograms(icc_dztwins_myiscgamma, icc_dzstranger_myiscgamma, 'DZ rtconf\_corr Bootstrap',colords)
legend('twin','stranger')
figure;
PlotHistograms(icc_mztwins_myiscgamma, icc_dztwins_myiscgamma, 'rtconf\_corr MZ DZ Bootstrap',colormd)
legend('MZ','DZ')

%
icc_mztwins_stdrtime = TwinsBS_ICC(twinsmz_stdrtime, 0);
icc_dztwins_stdrtime = TwinsBS_ICC(twinsdz_stdrtime, 0);
icc_mzstranger_stdrtime = TwinsBS_ICC(twinsmz_stdrtime, 1);
icc_dzstranger_stdrtime = TwinsBS_ICC(twinsdz_stdrtime, 1);

figure;
PlotHistograms(icc_mztwins_stdrtime, icc_mzstranger_stdrtime, 'MZ stdrtime Bootstrap',colorms)
legend('twin','stranger')
figure;
PlotHistograms(icc_dztwins_stdrtime, icc_dzstranger_stdrtime, 'DZ stdrtime Bootstrap',colords)
legend('twin','stranger')
figure;
PlotHistograms(icc_mztwins_stdrtime, icc_dztwins_stdrtime, 'stdrtime MZ DZ Bootstrap',colormd)
legend('MZ','DZ')

%
icc_mztwins_mconf = TwinsBS_ICC(twinsmz_mconf, 0);
icc_dztwins_mconf = TwinsBS_ICC(twinsdz_mconf, 0);
icc_mzstranger_mconf = TwinsBS_ICC(twinsmz_mconf, 1);
icc_dzstranger_mconf = TwinsBS_ICC(twinsdz_mconf, 1);
figure;
PlotHistograms(icc_mztwins_mconf, icc_mzstranger_mconf, 'MZ mconf Bootstrap',colorms)
legend('twin','stranger')
figure;
PlotHistograms(icc_dztwins_mconf, icc_dzstranger_mconf, 'DZ mconf Bootstrap',colords)
legend('twin','stranger')
figure;
PlotHistograms(icc_mztwins_mconf, icc_dztwins_mconf, 'mconf MZ DZ Bootstrap',colormd)
legend('MZ','DZ')

%%%
mzremove = any([mean(twinsmz_myrtcorr(:,[1,2]),2),mean(twinsmz_myrtcorr(:,[3,4]),2)]>=0, 2);
dzremove = any([mean(twinsdz_myrtcorr(:,[1,2]),2),mean(twinsdz_myrtcorr(:,[3,4]),2)]>=0, 2);
twinsmz_myrtcorrclear = twinsmz_myrtcorr(~mzremove, :);
twinsdz_myrtcorrclear = twinsdz_myrtcorr(~dzremove, :);

icc_mztwins_myrtcorrclear = TwinsBS_ICC(twinsmz_myrtcorrclear, 0);
icc_dztwins_myrtcorrclear = TwinsBS_ICC(twinsdz_myrtcorrclear, 0);
icc_mzstranger_myrtcorrclear = TwinsBS_ICC(twinsmz_myrtcorrclear, 1);
icc_dzstranger_myrtcorrclear = TwinsBS_ICC(twinsdz_myrtcorrclear, 1);
figure;
PlotHistograms(icc_mztwins_myrtcorrclear, icc_mzstranger_myrtcorrclear, 'MZ rtconf\_corr remove Bootstrap',colorms)
legend('twin','stranger')
figure;
PlotHistograms(icc_dztwins_myrtcorrclear, icc_dzstranger_myrtcorrclear, 'DZ rtconf\_corr remove Bootstrap',colords)
legend('twin','stranger')
figure;
PlotHistograms(icc_mztwins_myrtcorrclear, icc_dztwins_myrtcorrclear, 'rtconf\_corr remove MZ DZ Bootstrap',colormd)
legend('MZ','DZ')


%% Find Outliners in MZ

diffmzauc = abs([twinsmz_auc(:,1)-twinsmz_auc(:,3), twinsmz_auc(:,1)-twinsmz_auc(:,4), twinsmz_auc(:,2)-twinsmz_auc(:,3), twinsmz_auc(:,2)-twinsmz_auc(:,4)]);
diffdzauc = abs([twinsdz_auc(:,1)-twinsdz_auc(:,3), twinsdz_auc(:,1)-twinsdz_auc(:,4), twinsdz_auc(:,2)-twinsdz_auc(:,3), twinsdz_auc(:,2)-twinsdz_auc(:,4)]);
meandiffmz = mean(diffmzauc, 2);
meandiffdz = mean(diffdzauc, 2);
diffmz_icc = ICC(diffmzauc, 'C-k');
diffdz_icc = ICC(diffdzauc, 'C-k');

figure;
voi = diffmzauc;
plot(voi, 'o')
hold on
plot([1,length(voi)], [0,0],'--')
hold on
plot(meandiffmz,'-*')
hold on
for ii = 1:length(voi)
    plot([ii,ii],[min(voi(ii,:)),max(voi(ii,:))],'k-')
    hold on
end
mztxt = sprintf('MZ Cronbach''s Alpha/ICC(C-k)= %.3f', diffmz_icc);
title(mztxt)
legend('A1-B1', 'A1-B2', 'A2-B1', 'A2-B2')
ylim([-0.4, 0.4])

figure;
voi = diffdzauc;
plot(voi, 'o')
hold on
plot([1,length(voi)], [0,0],'--')
hold on
plot(meandiffdz,'-*')
hold on
for ii = 1:length(voi)
    plot([ii,ii],[min(voi(ii,:)),max(voi(ii,:))],'k-')
    hold on
end
dztxt = sprintf('DZ Cronbach''s Alpha/ICC(C-k)= %.3f', diffdz_icc);
title(dztxt)
legend('A1-B1', 'A1-B2', 'A2-B1', 'A2-B2')
ylim([-0.4, 0.4])

% TODO plot volin 
% figure;
% boxplot(meandiffdz)

mztwinNum = tblmz.twinsNum(1:2:end);
mztwinNum(:,2) = num2cell(meandiffmz);
mztwinNum(:,3) = num2cell(abs(meandiffmz));
mztwinNum = sortrows(mztwinNum, -3);


%% Find Outliners in MZ aucresid

diffmzaucresid = [twinsmz_aucresid(:,1)-twinsmz_aucresid(:,3), twinsmz_aucresid(:,1)-twinsmz_aucresid(:,4), twinsmz_aucresid(:,2)-twinsmz_aucresid(:,3), twinsmz_aucresid(:,2)-twinsmz_aucresid(:,4)];
diffdzaucresid = [twinsdz_aucresid(:,1)-twinsdz_aucresid(:,3), twinsdz_aucresid(:,1)-twinsdz_aucresid(:,4), twinsdz_aucresid(:,2)-twinsdz_aucresid(:,3), twinsdz_aucresid(:,2)-twinsdz_aucresid(:,4)];
meandiffmz = mean(diffmzaucresid, 2);
meandiffdz = mean(diffdzaucresid, 2);
diffmz_icc = ICC(diffmzaucresid, 'C-k');
diffdz_icc = ICC(diffdzaucresid, 'C-k');

figure;
voi = diffmzaucresid;
plot(voi, 'o')
hold on
plot([1,length(voi)], [0,0],'--')
hold on
plot(meandiffmz,'-*')
hold on
for ii = 1:length(voi)
    plot([ii,ii],[min(voi(ii,:)),max(voi(ii,:))],'k-')
    hold on
end
mztxt = sprintf('MZ Cronbach''s Alpha/ICC(C-k)= %.3f', diffmz_icc);
title(mztxt)
legend('A1-B1', 'A1-B2', 'A2-B1', 'A2-B2')
ylim([-0.4, 0.4])

figure;
voi = diffdzaucresid;
plot(voi, 'o')
hold on
plot([1,length(voi)], [0,0],'--')
hold on
plot(meandiffdz,'-*')
hold on
for ii = 1:length(voi)
    plot([ii,ii],[min(voi(ii,:)),max(voi(ii,:))],'k-')
    hold on
end
dztxt = sprintf('DZ Cronbach''s Alpha/ICC(C-k)= %.3f', diffdz_icc);
title(dztxt)
legend('A1-B1', 'A1-B2', 'A2-B1', 'A2-B2')
ylim([-0.4, 0.4])

% TODO plot volin 
% figure;
% boxplot(meandiffdz)

mztwinNumresid = tblmz.twinsNum(1:2:end);
mztwinNumresid(:,2) = num2cell(meandiffmz);
mztwinNumresid(:,3) = num2cell(abs(meandiffmz));
mztwinNumresid = sortrows(mztwinNumresid, -3);

%%
figure; PlotIntraClass([mean(twinsmz_myrtcorr(:,[1,2]),2),mean(twinsmz_myrtcorr(:,[3,4]),2)], '1-1', 'mz rt\_conf')

%% Calculate Cronbach's alpha
% accu mrtime stdrtime mconf auc rt_conf_corr iscgamma
% self_accu_mz = self_accu_mz;
% self_mrtime_mz
% self_stdrtime_mz
% self_mconf_mz
% self_auc_mz
% self_myrtcorr_mz
% self_myiscgamma_mz

times = 1e5;
nmz = length(self_accu_mz);
nsample = floor(nmz*0.75);
for ii = times:-1:1
    idx = randperm(nmz, nsample);
    
    tmp1 = self_accu_mz(idx, :);
    tmp2 = self_mrtime_mz(idx, :);
    tmp3 = self_stdrtime_mz(idx, :);
    tmp4 = self_mconf_mz(idx, :);
    tmp5 = self_auc_mz(idx, :);
    tmp6 = self_myrtcorr_mz(idx, :);
    tmp7 = self_myiscgamma_mz(idx, :);

    allalphamz(ii,1) = ICC(tmp1, 'C-k');
    allalphamz(ii,2) = ICC(tmp2, 'C-k');
    allalphamz(ii,3) = ICC(tmp3, 'C-k');
    allalphamz(ii,4) = ICC(tmp4, 'C-k');
    allalphamz(ii,5) = ICC(tmp5, 'C-k');
    allalphamz(ii,6) = ICC(tmp6, 'C-k');
    allalphamz(ii,7) = ICC(tmp7, 'C-k');

end

times = 1e5;
ndz = length(self_accu_dz);
nsample = floor(ndz*0.75);
for ii = times:-1:1
    idx = randperm(ndz, nsample);
    
    tmp1 = self_accu_dz(idx, :);
    tmp2 = self_mrtime_dz(idx, :);
    tmp3 = self_stdrtime_dz(idx, :);
    tmp4 = self_mconf_dz(idx, :);
    tmp5 = self_auc_dz(idx, :);
    tmp6 = self_myrtcorr_dz(idx, :);
    tmp7 = self_myiscgamma_dz(idx, :);

    allalphadz(ii,1) = ICC(tmp1, 'C-k');
    allalphadz(ii,2) = ICC(tmp2, 'C-k');
    allalphadz(ii,3) = ICC(tmp3, 'C-k');
    allalphadz(ii,4) = ICC(tmp4, 'C-k');
    allalphadz(ii,5) = ICC(tmp5, 'C-k');
    allalphadz(ii,6) = ICC(tmp6, 'C-k');
    allalphadz(ii,7) = ICC(tmp7, 'C-k');

end

%% dprime about icc bootstrap result
distsn = icc_mztwins_accu;
distn = icc_dztwins_accu;

dprime_1 = mean(distsn)/std(distsn) - mean(distn)/std(distn);


[h,p,zstat] = Ztest_std(icc_mztwins_mcoh, icc_mzstranger_mcoh)
[h,p,zstat] = Ztest_std(icc_mztwins_mconf, icc_mzstranger_mconf)
[h,p,zstat] = Ztest_std(icc_mztwins_mrtime, icc_mzstranger_mrtime)
[h,p,zstat] = Ztest_std(icc_mztwins_stdrtime, icc_mzstranger_stdrtime)
[h,p,zstat] = Ztest_std(icc_mztwins_myrtcorrclear, icc_mzstranger_myrtcorrclear)
[h,p,zstat] = Ztest_std(icc_mztwins_auc, icc_mzstranger_auc)
[h,p,zstat] = Ztest_std(icc_mztwins_aucresid, icc_mzstranger_aucresid)
[h,p,zstat] = Ztest_std(icc_mztwins_myiscgamma, icc_mzstranger_myiscgamma)

[h,p,zstat] = Ztest_std(icc_dztwins_mcoh, icc_dzstranger_mcoh)
[h,p,zstat] = Ztest_std(icc_dztwins_mconf, icc_dzstranger_mconf)
[h,p,zstat] = Ztest_std(icc_dztwins_mrtime, icc_dzstranger_mrtime)
[h,p,zstat] = Ztest_std(icc_dztwins_stdrtime, icc_dzstranger_stdrtime)
[h,p,zstat] = Ztest_std(icc_dztwins_myrtcorrclear, icc_dzstranger_myrtcorrclear)
[h,p,zstat] = Ztest_std(icc_dztwins_auc, icc_dzstranger_auc)
[h,p,zstat] = Ztest_std(icc_dztwins_aucresid, icc_dzstranger_aucresid)
[h,p,zstat] = Ztest_std(icc_dztwins_myiscgamma, icc_dzstranger_myiscgamma)

[h,p,zstat] = Ztest_std(icc_mztwins_mcoh, icc_dztwins_mcoh)
[h,p,zstat] = Ztest_std(icc_mztwins_mconf, icc_dztwins_mconf)
[h,p,zstat] = Ztest_std(icc_mztwins_mrtime, icc_dztwins_mrtime)
[h,p,zstat] = Ztest_std(icc_mztwins_stdrtime, icc_dztwins_stdrtime)
[h,p,zstat] = Ztest_std(icc_mztwins_myrtcorrclear, icc_dztwins_myrtcorrclear)
[h,p,zstat] = Ztest_std(icc_mztwins_auc, icc_dztwins_auc)
[h,p,zstat] = Ztest_std(icc_mztwins_aucresid, icc_dztwins_aucresid)
[h,p,zstat] = Ztest_std(icc_mztwins_myiscgamma, icc_dztwins_myiscgamma)

[~,p(1),zstat(1)] = Ztest_std(icc_mztwins_mrtime, 0);
[~,p(2),zstat(2)] = Ztest_std(icc_dztwins_mrtime, 0);
[~,p(3),zstat(3)] = Ztest_std(icc_mzstranger_mrtime, 0);
[~,p(4),zstat(4)] = Ztest_std(icc_dzstranger_mrtime, 0);
[p', zstat']

[~,p(1),zstat(1)] = Ztest_std(icc_mztwins_stdrtime, 0);
[~,p(2),zstat(2)] = Ztest_std(icc_dztwins_stdrtime, 0);
[~,p(3),zstat(3)] = Ztest_std(icc_mzstranger_stdrtime, 0);
[~,p(4),zstat(4)] = Ztest_std(icc_dzstranger_stdrtime, 0);
[p', zstat']

%%
% self_accu_mz % self_mrtime_mz % self_stdrtime_mz % self_mconf_mz
% self_auc_mz % self_myrtcorr_mz % self_myiscgamma_mz
[~,p,zstat] = Ztest_std(allalphamz(:,1), allalphadz(:,1))
[~,p,zstat] = Ztest_std(corr_self_accumz, corr_self_accudz)

% [~,p(1),zstat(1)] = Ztest_std(corr_self_accumz, 0);
% [~,p(2),zstat(2)] = Ztest_std(corr_self_accudz, 0);
% [~,p(3),zstat(3)] = Ztest_std(allalphamz(:,1), 0);
% [~,p(4),zstat(4)] = Ztest_std(allalphadz(:,1), 0);
% [p', zstat']
[~,p,zstat] = Ztest_std(allalphamz(:,2), allalphadz(:,2))
[~,p,zstat] = Ztest_std(corr_self_mrtimemz, corr_self_mrtimedz)

[~,p,zstat] = Ztest_std(allalphamz(:,3), allalphadz(:,3))
[~,p,zstat] = Ztest_std(corr_self_stdrtimemz, corr_self_stdrtimedz)

[~,p,zstat] = Ztest_std(allalphamz(:,4), allalphadz(:,4))
[~,p,zstat] = Ztest_std(corr_self_mconfmz, corr_self_mconfdz)

[~,p,zstat] = Ztest_std(allalphamz(:,5), allalphadz(:,5))
[~,p,zstat] = Ztest_std(corr_self_aucmz, corr_self_aucdz)

[~,p,zstat] = Ztest_std(allalphamz(:,6), allalphadz(:,6))
[~,p,zstat] = Ztest_std(corr_self_myrtcorrmz, corr_self_myrtcorrdz)

[~,p,zstat] = Ztest_std(allalphamz(:,7), allalphadz(:,7))
[~,p,zstat] = Ztest_std(corr_self_myiscgammamz, corr_self_myiscgammadz)

%%
tmpmz = [self_auc_mz, self_myrtcorr_mz*-1, self_myiscgamma_mz];
ICC(tmpmz, 'C-k')
tmpdz = [mean(self_auc_dz, 2), mean(self_myrtcorr_dz*-1, 2), mean(self_myiscgamma_dz, 2)];
ICC(tmpdz, 'C-k')

times = 1e5;
allalpha = [];
% nmz = length(atmp);
% nsample = floor(nmz*0.75);
tic;
for ii = times:-1:1
    idx = randperm(length(tmpmz), floor(length(tmpmz)*0.75));
    thistmpa = tmpmz(idx,:); %
    idx = randperm(length(tmpdz), floor(length(tmpdz)*0.75));
    thistmpb = tmpdz(idx,:); %
    
    allalpha(ii,1) = ICC(thistmpa, 'C-k');
    allalpha(ii,2) = ICC(thistmpb, 'C-k');
end
toc();
alphardmmz_3metacog = allalpha(:,1);
alphardmdz_3metacog = allalpha(:,2);


%%
toc(st)
