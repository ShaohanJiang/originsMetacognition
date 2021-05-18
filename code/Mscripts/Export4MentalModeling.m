% export for mentalization ACE model

% load guess data, load rdm data?
clear;home;

% colorms = [1,0,0; 0.5,0.5,0.5];
% colords = [0,1,0; 0.5,0.5,0.5];
% colormd = [1,0,0; 0,1,0];

tblguess = readtable('result_files\Guessin1sessions1201-18;43;41.csv');
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
selfrdmauc1 = mean([tblrdm.myauc1(1:2:end), tblrdm.myauc2(1:2:end)],2);
selfrdmauc2 = mean([tblrdm.myauc1(2:2:end), tblrdm.myauc2(2:2:end)],2);
selfrdmaucresid1 = mean([tblrdm.myaucresid1(1:2:end), tblrdm.myaucresid2(1:2:end)],2);
selfrdmaucresid2 = mean([tblrdm.myaucresid1(2:2:end), tblrdm.myaucresid2(2:2:end)],2);
selfaccu1 = mean([tblrdm.accuracy1(1:2:end), tblrdm.accuracy2(1:2:end)],2);
selfaccu2 = mean([tblrdm.accuracy1(2:2:end), tblrdm.accuracy2(2:2:end)],2);
mcoh1 = tblrdm.mcoh(1:2:end);
mcoh2 = tblrdm.mcoh(2:2:end);
rtconfcorr1 = mean([tblrdm.myrtcorr1(1:2:end), tblrdm.myrtcorr2(1:2:end)],2);
rtconfcorr2 = mean([tblrdm.myrtcorr1(2:2:end), tblrdm.myrtcorr2(2:2:end)],2);

%% for ACDE modeling, multivariates, 
% [daytime, twinsNum, zyg, ismale, age, name1, name2, selfrdmauc1, selfrdmauc2, selfguessauc1, selfguessauc2, otherrdmauc1, otherrdmauc2]

%%%%%%%%%%%%%% Twins %%%%%%%%%%%%%%%%
if ~isequal(tblrdm.myname, tbltwins.myname)
    warning('Please Check twins sub''s name order!!')    
end
tbltwinmentalizing = table();
tbltwinmentalizing.daytime = tblrdm.daytime(1:2:end);
tbltwinmentalizing.twinsNum = tblrdm.twinsNum(1:2:end);
tbltwinmentalizing.zyg = tblrdm.zyg(1:2:end);
tbltwinmentalizing.ismale = tblrdm.ismale(1:2:end);
tbltwinmentalizing.age = tblrdm.age(1:2:end);
tbltwinmentalizing.name1 = tblrdm.myname(1:2:end);
tbltwinmentalizing.name2 = tblrdm.myname(2:2:end);

tbltwinmentalizing.mcoh1 = tblrdm.mcoh(1:2:end);
tbltwinmentalizing.mcoh2 = tblrdm.mcoh(2:2:end);
tbltwinmentalizing.selfaccu1 = mean([tblrdm.accuracy1(1:2:end), tblrdm.accuracy2(1:2:end)],2);
tbltwinmentalizing.selfaccu2 = mean([tblrdm.accuracy1(2:2:end), tblrdm.accuracy2(2:2:end)],2);
tbltwinmentalizing.selfrdmauc1 = mean([tblrdm.myauc1(1:2:end), tblrdm.myauc2(1:2:end)],2);
tbltwinmentalizing.selfrdmauc2 = mean([tblrdm.myauc1(2:2:end), tblrdm.myauc2(2:2:end)],2);
tbltwinmentalizing.selfrdmaucresid1 = mean([tblrdm.myaucresid1(1:2:end), tblrdm.myaucresid2(1:2:end)],2);
tbltwinmentalizing.selfrdmaucresid2 = mean([tblrdm.myaucresid1(2:2:end), tblrdm.myaucresid2(2:2:end)],2);
tbltwinmentalizing.selfrtconfcorr1 = mean([tblrdm.myrtcorr1(1:2:end), tblrdm.myrtcorr2(1:2:end)],2);
tbltwinmentalizing.selfrtconfcorr2 = mean([tblrdm.myrtcorr1(2:2:end), tblrdm.myrtcorr2(2:2:end)],2);
tbltwinmentalizing.rtweight1 = tbltwins.rtweight(1:2:end);
tbltwinmentalizing.rtweight2 = tbltwins.rtweight(2:2:end);
tbltwinmentalizing.myiscgamma1 = tbltwins.myiscgamma(1:2:end);
tbltwinmentalizing.myiscgamma2 = tbltwins.myiscgamma(2:2:end);
tbltwinmentalizing.myiscgammahigh1 = tbltwins.myiscgammahigh(1:2:end);
tbltwinmentalizing.myiscgammahigh2 = tbltwins.myiscgammahigh(2:2:end);
tbltwinmentalizing.selfguessauc1 = tbltwins.myauc(1:2:end);
tbltwinmentalizing.selfguessauc2 = tbltwins.myauc(2:2:end);
tbltwinmentalizing.selffitauc1 = tbltwins.myfitauc(1:2:end);
tbltwinmentalizing.selffitauc2 = tbltwins.myfitauc(2:2:end);
tbltwinmentalizing.otherrdmauc1 = tbltwins.otherauc(1:2:end);
tbltwinmentalizing.otherrdmauc2 = tbltwins.otherauc(2:2:end);
tbltwinmentalizing.selfguessaucresid1 = tbltwins.myaucresidhigh(1:2:end);
tbltwinmentalizing.selfguessaucresid2 = tbltwins.myaucresidhigh(2:2:end);
tbltwinmentalizing.otherrdmaucresid1 = tbltwins.otheraucresidhigh(1:2:end);
tbltwinmentalizing.otherrdmaucresid2 = tbltwins.otheraucresidhigh(2:2:end);


%%%%%%%%%%%%%% Strangers %%%%%%%%%%%%%%%%%%%%%
if ~isequal(tblrdm.myname, tblstrangers.myname)
    warning('Please Check strangers sub''s name order!!')    
end
tblstrangermentalizing = table();
tblstrangermentalizing.daytime = tblrdm.daytime(1:2:end);
tblstrangermentalizing.twinsNum = tblrdm.twinsNum(1:2:end);
tblstrangermentalizing.zyg = tblrdm.zyg(1:2:end);
tblstrangermentalizing.ismale = tblrdm.ismale(1:2:end);
tblstrangermentalizing.age = tblrdm.age(1:2:end);
tblstrangermentalizing.name1 = tblrdm.myname(1:2:end);
tblstrangermentalizing.name2 = tblrdm.myname(2:2:end);

tblstrangermentalizing.mcoh1 = tblrdm.mcoh(1:2:end);
tblstrangermentalizing.mcoh2 = tblrdm.mcoh(2:2:end);
tblstrangermentalizing.selfaccu1 = mean([tblrdm.accuracy1(1:2:end), tblrdm.accuracy2(1:2:end)],2);
tblstrangermentalizing.selfaccu2 = mean([tblrdm.accuracy1(2:2:end), tblrdm.accuracy2(2:2:end)],2);
tblstrangermentalizing.selfrdmauc1 = mean([tblrdm.myauc1(1:2:end), tblrdm.myauc2(1:2:end)],2);
tblstrangermentalizing.selfrdmauc2 = mean([tblrdm.myauc1(2:2:end), tblrdm.myauc2(2:2:end)],2);
tblstrangermentalizing.selfrdmaucresid1 = mean([tblrdm.myaucresid1(1:2:end), tblrdm.myaucresid2(1:2:end)],2);
tblstrangermentalizing.selfrdmaucresid2 = mean([tblrdm.myaucresid1(2:2:end), tblrdm.myaucresid2(2:2:end)],2);
tbltwinmentalizing.selfrtconfcorr1 = mean([tblrdm.myrtcorr1(1:2:end), tblrdm.myrtcorr2(1:2:end)],2);
tbltwinmentalizing.selfrtconfcorr2 = mean([tblrdm.myrtcorr1(2:2:end), tblrdm.myrtcorr2(2:2:end)],2);

tblstrangermentalizing.rtweight1 = tblstrangers.rtweight(1:2:end);
tblstrangermentalizing.rtweight2 = tblstrangers.rtweight(2:2:end);
tblstrangermentalizing.myiscgamma1 = tblstrangers.myiscgamma(1:2:end);
tblstrangermentalizing.myiscgamma2 = tblstrangers.myiscgamma(2:2:end);
tblstrangermentalizing.myiscgammahigh1 = tblstrangers.myiscgammahigh(1:2:end);
tblstrangermentalizing.myiscgammahigh2 = tblstrangers.myiscgammahigh(2:2:end);
tblstrangermentalizing.selfguessauc1 = tblstrangers.myauc(1:2:end);
tblstrangermentalizing.selfguessauc2 = tblstrangers.myauc(2:2:end);
tblstrangermentalizing.selffitauc1 = tblstrangers.myfitauc(1:2:end);
tblstrangermentalizing.selffitauc2 = tblstrangers.myfitauc(2:2:end);
tblstrangermentalizing.otherrdmauc1 = tblstrangers.otherauc(1:2:end);
tblstrangermentalizing.otherrdmauc2 = tblstrangers.otherauc(2:2:end);
tblstrangermentalizing.selfguessaucresid1 = tblstrangers.myaucresidhigh(1:2:end);
tblstrangermentalizing.selfguessaucresid2 = tblstrangers.myaucresidhigh(2:2:end);
tblstrangermentalizing.otherrdmaucresid1 = tblstrangers.otheraucresidhigh(1:2:end);
tblstrangermentalizing.otherrdmaucresid2 = tblstrangers.otheraucresidhigh(2:2:end);


%%
covars = [selfaccu1, selfaccu2];
[tbltwinmentalizing.mcohrm1, tbltwinmentalizing.mcohrm2] = RmCovarianceGLMtwins(covars, [mcoh1, mcoh2], tbltwinmentalizing.twinsNum, tbltwinmentalizing.zyg);
[tbltwinmentalizing.rdmaucrm1, tbltwinmentalizing.rdmaucrm2] = RmCovarianceGLMtwins(covars, [selfrdmauc1, selfrdmauc2], tbltwinmentalizing.twinsNum, tbltwinmentalizing.zyg);
[tbltwinmentalizing.rdmaucresidrm1, tbltwinmentalizing.rdmaucresidrm2] = RmCovarianceGLMtwins(covars, [selfrdmaucresid1, selfrdmaucresid2], tbltwinmentalizing.twinsNum, tbltwinmentalizing.zyg);
[tbltwinmentalizing.rtconfcorrrm1, tbltwinmentalizing.rtconfcorrrm2] = RmCovarianceGLMtwins(covars, [rtconfcorr1, rtconfcorr2], tbltwinmentalizing.twinsNum, tbltwinmentalizing.zyg);

[tblstrangermentalizing.mcohrm1, tblstrangermentalizing.mcohrm2] = RmCovarianceGLMtwins(covars, [mcoh1, mcoh2], tblstrangermentalizing.twinsNum, tblstrangermentalizing.zyg);
[tblstrangermentalizing.rdmaucrm1, tblstrangermentalizing.rdmaucrm2] = RmCovarianceGLMtwins(covars, [selfrdmauc1, selfrdmauc2], tblstrangermentalizing.twinsNum, tblstrangermentalizing.zyg);
[tblstrangermentalizing.rdmaucresidrm1, tblstrangermentalizing.rdmaucresidrm2] = RmCovarianceGLMtwins(covars, [selfrdmaucresid1, selfrdmaucresid2], tblstrangermentalizing.twinsNum, tblstrangermentalizing.zyg);
[tblstrangermentalizing.rtconfcorrrm1, tblstrangermentalizing.rtconfcorrrm2] = RmCovarianceGLMtwins(covars, [rtconfcorr1, rtconfcorr2], tblstrangermentalizing.twinsNum, tblstrangermentalizing.zyg);

%% save to files
resultfolder = 'result_files/';
dstr = datestr(now, 'mmdd-HH;MM;SS');
% writetable(tblguess, [resultfolder, 'Guessin1sessions' dstr '.xlsx'],'FileType','spreadsheet')
writetable(tbltwinmentalizing, [resultfolder, 'TwinMental' dstr '.csv'], 'FileType','text')
writetable(tblstrangermentalizing, [resultfolder, 'StrangerMental' dstr '.csv'], 'FileType','text')