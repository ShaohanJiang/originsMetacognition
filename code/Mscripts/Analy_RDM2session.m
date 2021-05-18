%% ALL RDM data for each session
% *_notguess_*log.mat
% sort as [twinA1, twinA2, twinB1, twinB2]
% 
% ControlTrain/[date]/[twins Pair Num]/[subject name]/[files]
clear;
home;
load('subinfo226.mat')
%% list files
resultfolder = 'result_files/';
% folders = dir('ControlTrain/*/*/*');
% subjects = [];
% for jj = 1:length(folders)
%     if ~strcmp(folders(jj).name,'.') && ~strcmp(folders(jj).name,'..')
%         subjects =[subjects, folders(jj)];
%     end
% end

% files = dir(['ControlTrain' filesep '*' filesep '*' filesep '*' filesep '*_notguess_*log.mat']);
files = dir(['samenumcoding' filesep '*' filesep '*' filesep '*_notguess_*log.mat']);
%% read and analysis
initmp = zeros(length(files),1);
mcoh = initmp;
accuracy = initmp;
myauc = initmp;
% otherauc = initmp;
myaucresid = initmp;
% otheraucresid = initmp;
mrtime = initmp;
stdrtime = initmp;
myrtcorr = initmp;
myiscgamma = initmp;
mconf = initmp;
% otherrtcorr = initmp;
% confcorrraw = initmp;
% confcorr_resid = initmp;
% confcorr_residbi = initmp;
nmissing = initmp;
sessNum = [];
myname = [];
% othername = [];
daytime = [];
twinsNum = [];

for ii = 1:length(files)
    filename = [files(ii).folder, filesep, files(ii).name];
    matvar = load(filename);
    tmpdata = matvar.data;
    
    nameidx = find(files(ii).name=='_');
    dayidx = find(files(ii).folder==filesep);
    
    clearidx = tmpdata.conf~=-1 & tmpdata.resp~=-1;
    
    nmissing(ii) = sum(~clearidx);
    
    rtime = tmpdata.rtime(clearidx);
    coh = tmpdata.coh(clearidx);
    isc = tmpdata.isc(clearidx);
    confraw = tmpdata.conf(clearidx);
    
    rxc_isc_conf = crosstab(isc, confraw>median(unique(confraw)));
    myiscgamma(ii) = gkgammatst(rxc_isc_conf);
    
    mconf(ii) = mean(confraw);
    conf = zscore(confraw);
%     conforig = tmpdata.conforig(clearidx);
%     conforig = zscore(conforig);
    
    
    myname{ii,1} = files(ii).name(nameidx(1)+1:nameidx(2)-1);
%     othername{ii,1} = files(ii).name(nameidx(6)+1:nameidx(7)-1);
    sessNum{ii,1} = files(ii).name(nameidx(7)+1:nameidx(8)-1);
    daytime{ii,1} = files(ii).folder(dayidx(end-2)+1:dayidx(end-1)-1);
    twinsNum{ii,1} = files(ii).folder(dayidx(end-1)+1:dayidx(end)-1);
    
    mcoh(ii) = mean(coh);
    accuracy(ii) = mean(isc);
    
    mrtime(ii) = mean(rtime);
    stdrtime(ii) = std(rtime);
    dmrtime = rtime - mrtime(ii);
    myrtcorr(ii) = corr(rtime, conf);
%     otherrtcorr(ii) = corr(rtime, conforig);
    
%     [~,~,stat] = glmfit([rtime, rtime.^2, rtime.^3, rtime.^4, rtime.^5], conf);
    [~,~,stat] = glmfit([dmrtime, dmrtime.^2, dmrtime.^3, dmrtime.^4, dmrtime.^5], conf);
    [~,~,~,myauc(ii)] = perfcurve(isc, conf, true);
    [~,~,~,myaucresid(ii)] = perfcurve(isc, stat.resid, true);

    
end

tbl = table(daytime, twinsNum, sessNum, myname, ...
    mcoh, accuracy, mconf, mrtime, stdrtime, myrtcorr, myiscgamma, myauc, myaucresid, nmissing);
tbl = sortrows(tbl, 'twinsNum');

%% split two sessions
daytime = tbl.daytime(1:2:end);
bilen = length(daytime);
zyg = subinfo.zyg;
ismale = subinfo.ismale;
age = subinfo.age;
twinsNum = tbl.twinsNum(1:2:end);
myname = tbl.myname(1:2:end);
mcoh = tbl.mcoh(1:2:end);
sessNum1 = tbl.sessNum(1:2:end);
sessNum2 = tbl.sessNum(2:2:end);
accuracy1 = tbl.accuracy(1:2:end);
accuracy2 = tbl.accuracy(2:2:end);
mconf1 = tbl.mconf(1:2:end);
mconf2 = tbl.mconf(2:2:end);
mrtime1 = tbl.mrtime(1:2:end);
mrtime2 = tbl.mrtime(2:2:end);
stdrtime1 = tbl.stdrtime(1:2:end);
stdrtime2 = tbl.stdrtime(2:2:end);
myrtcorr1 = tbl.myrtcorr(1:2:end);
myrtcorr2 = tbl.myrtcorr(2:2:end);
myiscgamma1 = tbl.myiscgamma(1:2:end);
myiscgamma2 = tbl.myiscgamma(2:2:end);
myauc1 = tbl.myauc(1:2:end);
myauc2 = tbl.myauc(2:2:end);
myaucresid1 = tbl.myaucresid(1:2:end);
myaucresid2 = tbl.myaucresid(2:2:end);
nmissing1 = tbl.nmissing(1:2:end);
nmissing2 = tbl.nmissing(2:2:end);

tblnew = table(daytime, twinsNum, zyg, ismale, age, myname, mcoh, sessNum1, sessNum2, ...
    accuracy1, accuracy2, mconf1, mconf2, mrtime1, mrtime2, stdrtime1, stdrtime2, myrtcorr1, myrtcorr2, ...
    myiscgamma1, myiscgamma2, myauc1, myauc2, myaucresid1, myaucresid2, nmissing1, nmissing2);

%%
dstr = datestr(now, 'mmdd-HH;MM;SS');

writetable(tblnew, [resultfolder, 'RDM2sessions', dstr, '.csv'],'FileType','text')
