% 计算所有RDM任务的AUC的平均值
% 去除第一个session的值
% 保存每一个session的正确率和auc
% 计算平均正确率和auc
%% 
% 读取原始mat文件，将多个session合成一个session做分析
% 读取训练数据，因为是staircase控制的正确率，所以尝试分析下正确率相同的情况下
% AUC和MCOH是否有遗传性
clear;
home;
%%
resultfolder = 'result_files/';
folders = dir('ControlTrain/*/*/*');
subjects = [];
for jj = 1:length(folders)
    if ~strcmp(folders(jj).name,'.') && ~strcmp(folders(jj).name,'..')
        subjects =[subjects, folders(jj)];
    end
end

%%
% /*_notguess_*log.mat

initmp = zeros(length(subjects),1);
% mcoh = initmp;
% vcoh = initmp;
accuracy = initmp;
myauc = initmp;
myaucresid = initmp;
% mrtime = initmp;
% myrtcorr = initmp;
nsession = initmp;
nmissing = initmp;
% nconf = initmp;
% nresp = initmp;
% isfb = initmp;
% taskorder = [];
myname = [];
daytime = [];

for jj = 1:length(subjects)

    taskfb = dir(fullfile(subjects(jj).folder, subjects(jj).name, '*_training_feedback_*log.mat'));
    tasknfb = dir(fullfile(subjects(jj).folder, subjects(jj).name, '*_training_nofeedback_*log.mat'));
    taskng = dir(fullfile(subjects(jj).folder, subjects(jj).name, '*_notguess_*log.mat'));
    
    if length(tasknfb)>=2
        tasknfb(end) = []; % 去除最后一个训练sessin
    end
    task = [taskfb(2:end); tasknfb; taskng]; % 去除第一个训练session

    
    nsess = length(task);
    nsession(jj) = nsess;
    dataall = [];
    for ss = 1:nsess
        mattmp = load(fullfile(task(ss).folder, task(ss).name));
        %         dataall = [dataall, mattmp.data];
        dataall = mattmp.data;
        
        clearidx = dataall.conf~=-1 & dataall.resp~=-1;
        smissing = sum(~clearidx);
        
        rtime = dataall.rtime(clearidx);
        coh = dataall.coh(clearidx);
        isc = dataall.isc(clearidx);
        conf = dataall.conf(clearidx);
        confz = zscore(conf); % 现在是对每个session的conf做z变换
        
        
        saccu = mean(isc);
        [~,~,~,sauc] = perfcurve(isc, confz, true);
        [~,~,stat] = glmfit([rtime, rtime.^2, rtime.^3, rtime.^4, rtime.^5], confz);
        [~,~,~,saucresid] = perfcurve(isc, stat.resid, true);
%         mrtime(jj) = mean(rtime);
%         myrtcorr(jj) = corr(rtime, confz);
%         mcoh(jj) = mean(coh(end-19:end));
%         vcoh(jj) = var(coh(end-19:end));
        rescell{jj}(ss,:) = [saccu, sauc, saucresid, smissing];
    end
%     dataall = EasyPTB.structcat(dataall,2);
    
    nameidx = find(task(ss).name=='_');
    dayidx = find(task(ss).folder=='\');
    
    myname{jj,1} = task(ss).name(nameidx(1)+1:nameidx(2)-1);
%     taskorder{ss,1} = task(ss).name(nameidx(6)+1:nameidx(7)-1);
    daytime{jj,1} = task(ss).folder(dayidx(end-2)+1:dayidx(end-1)-1);
    twinsNum{jj,1} = task(ss).folder(dayidx(end-1)+1:dayidx(end)-1);
    
    restmp = mean(rescell{jj});
    accuracy(jj) = restmp(1);
    myauc(jj) = restmp(2);
    myaucresid(jj) = restmp(3);
    nmissing(jj) = sum(rescell{jj}(:,4));
  
%     nconf(jj) = length(tabulate(conf));
%     nresp(jj) = length(tabulate(dataall.resp(clearidx)));
    

    
    % 有没有可能分析一下四个方向的正确率和auc？

end
%% RANK
% rankauc 
% rankaccu
% rankmcoh
zaccu = zscore(accuracy);
% zmcoh = zscore(mcoh);
zauc = zscore(myauc);

%%
% tblrdm = table(daytime, twinsNum, myname, isfb, mcoh, vcoh, accuracy, mrtime, myrtcorr, myauc, myaucresid, zaccu, zmcoh, zauc, nmissing);
tblrdm = table(daytime, twinsNum, myname, accuracy, myauc, myaucresid, zaccu, zauc, nmissing);
tblrdm = sortrows(tblrdm, 'twinsNum');

%% 拆分成每对twins同一行的数据格式
daytime = tblrdm.daytime(1:2:end);
twinsNum = tblrdm.twinsNum(1:2:end);
zyg = ones(length(twinsNum),1);
ismale = zyg;
age = zyg;
name1 = tblrdm.myname(1:2:end);
name2 = tblrdm.myname(2:2:end);
% isfb1 = tblrdm.isfb(1:2:end);
% isfb2 = tblrdm.isfb(2:2:end);
% mcoh1 = tblrdm.mcoh(1:2:end);
% mcoh2 = tblrdm.mcoh(2:2:end);
% vcoh1 = tblrdm.vcoh(1:2:end);
% vcoh2 = tblrdm.vcoh(2:2:end);
accu1 = tblrdm.accuracy(1:2:end);
accu2 = tblrdm.accuracy(2:2:end);
% mrtime1 = tblrdm.mrtime(1:2:end);
% mrtime2 = tblrdm.mrtime(2:2:end);
% rtcorr1 = tblrdm.myrtcorr(1:2:end);
% rtcorr2 = tblrdm.myrtcorr(2:2:end);
auc1 = tblrdm.myauc(1:2:end);
auc2 = tblrdm.myauc(2:2:end);
aucresid1 = tblrdm.myaucresid(1:2:end);
aucresid2 = tblrdm.myaucresid(2:2:end);
nmissing1 = tblrdm.nmissing(1:2:end);
nmissing2 = tblrdm.nmissing(2:2:end);
zaccu1 = tblrdm.zaccu(1:2:end);
zaccu2 = tblrdm.zaccu(2:2:end);
% zmcoh1 = tblrdm.zmcoh(1:2:end);
% zmcoh2 = tblrdm.zmcoh(2:2:end);
zauc1 = tblrdm.zauc(1:2:end);
zauc2 = tblrdm.zauc(2:2:end);
% tblrdmnew = table(daytime, twinsNum, zyg, ismale, age, name1, name2, isfb1, isfb2, ...
%     mcoh1, mcoh2, vcoh1, vcoh2, accu1, accu2, mrtime1, mrtime2, rtcorr1, rtcorr2, ...
%     auc1, auc2, aucresid1, aucresid2, zaccu1, zaccu2, zmcoh1, zmcoh2, zauc1, zauc2, ...
%     nmissing1, nmissing2);
tblrdmnew = table(daytime, twinsNum, zyg, ismale, age, name1, name2, ...
    accu1, accu2, ...
    auc1, auc2, aucresid1, aucresid2, zaccu1, zaccu2, zauc1, zauc2, ...
    nmissing1, nmissing2);

%%
dstr = datestr(now, 'mmdd-HH;MM;SS');
% writetable(tblrdmnew, [resultfolder, 'RDMin1session' dstr '.xlsx'],'FileType','spreadsheet')
writetable(tblrdmnew, [resultfolder, 'RDMallin1session' dstr '.csv'],'FileType','text')