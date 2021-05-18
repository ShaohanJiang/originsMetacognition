%% CatRDM2sessionData
% 读取原始mat文件，将多个session合成一个session做分析
clear;
home;
load('subinfo226.mat')
%%
resultfolder = 'result_files/';
% folders = dir('ControlTrain/*/*/*');
folders = dir('samenumcoding/*/*');
subjects = [];
for jj = 1:length(folders)
    if ~strcmp(folders(jj).name,'.') && ~strcmp(folders(jj).name,'..')
        subjects =[subjects, folders(jj)];
    end
end

%%
% /*_notguess_*log.mat

initmp = zeros(length(subjects),1);
mcoh = initmp;
accuracy = initmp;
myauc = initmp;
myaucresid = initmp;
mconf = initmp;
mrtime = initmp;
stdrtime = initmp;
myrtcorr = initmp;
myiscgamma = initmp;
nmissing = initmp;
nconf = initmp;
nresp = initmp;
% taskorder = [];
myname = [];
daytime = [];

for jj = 1:length(subjects)
    task = dir(fullfile(subjects(jj).folder, subjects(jj).name, '*_notguess_*log.mat'));
    nsess = length(task);
    if nsess == 0
        continue;
    end
    dataall = [];
    for ss = 1:nsess
        mattmp = load(fullfile(task(ss).folder, task(ss).name));
        dataall = [dataall, mattmp.data];
    end
    dataall = EasyPTB.structcat(dataall,2);
    
    nameidx = find(task(ss).name=='_');
    dayidx = find(task(ss).folder=='\');
    
    clearidx = dataall.conf~=-1 & dataall.resp~=-1;

    
    rtime = dataall.rtime(clearidx);
    coh = dataall.coh(clearidx);
    isc = dataall.isc(clearidx);
    
    conf = dataall.conf(clearidx); 
    mconf(jj,1) = mean(conf);
    confz = zscore(conf); % 现在是对2个session的conf做z变换
    
    nmissing(jj,1) = sum(~clearidx);   
    nconf(jj,1) = length(tabulate(conf));
    nresp(jj,1) = length(tabulate(dataall.resp(clearidx)));
    
    
    
    myname{jj,1} = task(ss).name(nameidx(1)+1:nameidx(2)-1);
%     taskorder{ss,1} = task(ss).name(nameidx(6)+1:nameidx(7)-1);
    daytime{jj,1} = task(ss).folder(dayidx(end-2)+1:dayidx(end-1)-1);
    twinsNum{jj,1} = task(ss).folder(dayidx(end-1)+1:dayidx(end)-1);
    
    
    accuracy(jj,1) = mean(isc);
    [~,~,~,myauc(jj,1)] = perfcurve(isc, confz, true);
    [~,~,stat] = glmfit([rtime, rtime.^2, rtime.^3, rtime.^4, rtime.^5], confz);
    [~,~,~,myaucresid(jj,1)] = perfcurve(isc, stat.resid, true);
    mrtime(jj,1) = mean(rtime);
    stdrtime(jj,1) = std(rtime);
    myrtcorr(jj,1) = corr(rtime, confz);
    mcoh(jj,1) = mean(coh);
    
    rxc_isc_conf = crosstab(isc, conf>median(unique(conf)));
    myiscgamma(jj,1) = gkgammatst(rxc_isc_conf);
    
    % 有没有可能分析一下四个方向的正确率和auc？

end
tblrdm = table(daytime, twinsNum, myname, mcoh, accuracy, mconf, mrtime, stdrtime, myrtcorr, myiscgamma, myauc, myaucresid, nmissing, nconf, nresp);
tblrdm = sortrows(tblrdm, 'twinsNum');

%% 拆分成每对twins同一行的数据格式
daytime = tblrdm.daytime(1:2:end);
twinsNum = tblrdm.twinsNum(1:2:end);
zyg = subinfo.zyg(1:2:end);
ismale = subinfo.ismale(1:2:end);
age = subinfo.age(1:2:end);
name1 = tblrdm.myname(1:2:end);
name2 = tblrdm.myname(2:2:end);
mcoh1 = tblrdm.mcoh(1:2:end);
mcoh2 = tblrdm.mcoh(2:2:end);
accu1 = tblrdm.accuracy(1:2:end);
accu2 = tblrdm.accuracy(2:2:end);
mconf1 = tblrdm.mconf(1:2:end);
mconf2 = tblrdm.mconf(2:2:end);
mrtime1 = tblrdm.mrtime(1:2:end);
mrtime2 = tblrdm.mrtime(2:2:end);
stdrtime1 = tblrdm.stdrtime(1:2:end);
stdrtime2 = tblrdm.stdrtime(2:2:end);
rtcorr1 = tblrdm.myrtcorr(1:2:end);
rtcorr2 = tblrdm.myrtcorr(2:2:end);
iscgamma1 = tblrdm.myiscgamma(1:2:end);
iscgamma2 = tblrdm.myiscgamma(2:2:end);
auc1 = tblrdm.myauc(1:2:end);
auc2 = tblrdm.myauc(2:2:end);
aucresid1 = tblrdm.myaucresid(1:2:end);
aucresid2 = tblrdm.myaucresid(2:2:end);
nmissing1 = tblrdm.nmissing(1:2:end);
nmissing2 = tblrdm.nmissing(2:2:end);
nconf1 = tblrdm.nconf(1:2:end);
nconf2 = tblrdm.nconf(2:2:end);
nresp1 = tblrdm.nresp(1:2:end);
nresp2 = tblrdm.nresp(2:2:end);
tblrdmnew = table(daytime, twinsNum, zyg, ismale, age, name1, name2, mcoh1, mcoh2, ...
    accu1, accu2, mconf1, mconf2, mrtime1, mrtime2, stdrtime1, stdrtime2, rtcorr1, rtcorr2, ...
    iscgamma1, iscgamma2, auc1, auc2, aucresid1, aucresid2, ...
     nmissing1, nmissing2, nconf1, nconf2, nresp1, nresp2);

%%
% eraseMZ = FindStrinCell({'T028','T001','T090','T055','T087','T007','T035','T053','T013','T054'}, ... % max ten pairs of MZ auc difference
%     tblrdmnew.twinsNum);
% tblrdmnew(eraseMZ,:) = [];
dstr = datestr(now, 'mmdd-HH;MM;SS');
% writetable(tblrdmnew, [resultfolder, 'RDMin1session' dstr '.xlsx'],'FileType','spreadsheet')
writetable(tblrdmnew, [resultfolder, 'RDMin1session' dstr '.csv'],'FileType','text')




