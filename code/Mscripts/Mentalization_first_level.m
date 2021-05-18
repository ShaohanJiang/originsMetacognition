% Mentalization first-level
clear;
home;
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
initmp = zeros(length(subjects)*2,1);
mcoh = initmp;
accuracy = initmp;
myauc = initmp;
myfitauc = initmp;
myfitauchigh = initmp;
otherauc = initmp;
myaucresid = initmp;
myaucresidhigh = initmp;
otheraucresid = initmp;
otheraucresidhigh = initmp;
mconf = initmp;
mrtime = initmp;
varrtime = initmp;
myiscgamma = initmp;
myiscgammahigh = initmp;
rtweight = initmp;
myrtcorr = initmp;
otherrtcorr = initmp;
confcorrraw = initmp;
confcorr_resid = initmp;
confcorr_residbi = initmp;
confcorr_residhigh = initmp;
% taskorder = [];
myname = [];
othername = [];
daytime = [];
twinsNum = [];

for jj = 1:length(subjects)
    task = dir(fullfile(subjects(jj).folder, subjects(jj).name, '*_guess_*log.mat'));
    nsess = length(task);
    dataall = [];
    if nsess==4
        for ss = 1:nsess
            if ss ==3
                dataall = [];
            end
            
            mattmp = load(fullfile(task(ss).folder, task(ss).name));
            dataall = [dataall, mattmp.data];
            
            if ~mod(ss,2)
                dataall = EasyPTB.structcat(dataall,2);
                
                ss2 = ss/2;
                nameidx = find(task(ss).name=='_');
                dayidx = find(task(ss).folder=='\');
                
                clearidx = dataall.conf~=-1 & dataall.resp~=-1;
                
                rtime = dataall.rtime(clearidx);
                coh = dataall.coh(clearidx);
                isc = dataall.isc(clearidx);
                
                confraw = dataall.conf(clearidx);
                mconf(ss2+(jj-1)*2,1) = mean(confraw);
                
                rxc_isc_conf = crosstab(isc, confraw>median(unique(confraw)));
                myiscgamma(ss2+(jj-1)*2,1) = gkgammatst(rxc_isc_conf);
    
                conf = zscore(confraw);
                conforig = dataall.conforig(clearidx);
                conforig = zscore(conforig);
                
                myname{ss2+(jj-1)*2,1} = task(ss).name(nameidx(1)+1:nameidx(2)-1);
                othername{ss2+(jj-1)*2,1} = task(ss).name(nameidx(6)+1:nameidx(7)-1);
                %     taskorder{ss,1} = task(ss).name(nameidx(6)+1:nameidx(7)-1);
                daytime{ss2+(jj-1)*2,1} = task(ss).folder(dayidx(end-2)+1:dayidx(end-1)-1);
                twinsNum{ss2+(jj-1)*2,1} = task(ss).folder(dayidx(end-1)+1:dayidx(end)-1);
                
                mcoh(ss2+(jj-1)*2,1) = mean(coh);
                accuracy(ss2+(jj-1)*2,1) = mean(isc);
                
                [~,~,stat] = glmfit(zscore(rtime), zscore(conf));
                fitconf = stat.beta(2)*zscore(rtime);
                [~,~,statorig] = glmfit(rtime, conforig);
                
                [~,~,stathigh] = glmfit([rtime, rtime.^2, rtime.^3, rtime.^4, rtime.^5], conf);
                fitconfhigh = stathigh.beta(1) + sum(stathigh.beta(2:end)' .* [rtime, rtime.^2, rtime.^3, rtime.^4, rtime.^5], 2);
                [~,~,statorighigh] = glmfit([rtime, rtime.^2, rtime.^3, rtime.^4, rtime.^5], conforig);
                
                [~,~,~,myauc(ss2+(jj-1)*2,1)] = perfcurve(isc, conf, true);
                [~,~,~,myfitauc(ss2+(jj-1)*2,1)] = perfcurve(isc, fitconf, true);
                [~,~,~,myfitauchigh(ss2+(jj-1)*2,1)] = perfcurve(isc, fitconfhigh, true);
                [~,~,~,myaucresid(ss2+(jj-1)*2,1)] = perfcurve(isc, stat.resid, true);
                [~,~,~,myaucresidhigh(ss2+(jj-1)*2,1)] = perfcurve(isc, stathigh.resid, true);
                [~,~,~,otherauc(ss2+(jj-1)*2,1)] = perfcurve(isc, conforig, true);
                [~,~,~,otheraucresid(ss2+(jj-1)*2,1)] = perfcurve(isc, statorig.resid, true);
                [~,~,~,otheraucresidhigh(ss2+(jj-1)*2,1)] = perfcurve(isc, statorighigh.resid, true);
                
                confresidhigh = stathigh.resid;
                rxc_isc_conf = crosstab(isc, confresidhigh>mean(confresidhigh));
                myiscgammahigh(ss2+(jj-1)*2,1) = gkgammatst(rxc_isc_conf);
            
                rtweight(ss2+(jj-1)*2,1) = stat.beta(2);
                mrtime(ss2+(jj-1)*2,1) = mean(rtime);
                varrtime(ss2+(jj-1)*2,1) = var(rtime);
                myrtcorr(ss2+(jj-1)*2,1) = corr(rtime, conf);
                otherrtcorr(ss2+(jj-1)*2,1) = corr(rtime, conforig);
                
                confcorrraw(ss2+(jj-1)*2,1) = corr(conf, conforig);
                confcorr_resid(ss2+(jj-1)*2,1) = corr(stat.resid, conforig);
                confcorr_residbi(ss2+(jj-1)*2,1) = corr(stat.resid, statorig.resid);
                confcorr_residhigh(ss2+(jj-1)*2,1) = corr(stathigh.resid, statorighigh.resid);
            end
            
        end
        
        
    elseif nsess ==2
        for ss = 1:nsess
            mattmp = load(fullfile(task(ss).folder, task(ss).name));
            
            dataall = mattmp.data;
            
            nameidx = find(task(ss).name=='_');
            dayidx = find(task(ss).folder=='\');
            
            clearidx = dataall.conf~=-1 & dataall.resp~=-1;
            
            rtime = dataall.rtime(clearidx);
            coh = dataall.coh(clearidx);
            isc = dataall.isc(clearidx);
            
            confraw = dataall.conf(clearidx);
            mconf(ss+(jj-1)*2,1) = mean(confraw);
            
            rxc_isc_conf = crosstab(isc, confraw>median(unique(confraw)));
            myiscgamma(ss+(jj-1)*2,1) = gkgammatst(rxc_isc_conf);
                
            conf = zscore(confraw);
            conforig = dataall.conforig(clearidx);
            conforig = zscore(conforig);
            
            myname{ss+(jj-1)*2,1} = task(ss).name(nameidx(1)+1:nameidx(2)-1);
            othername{ss+(jj-1)*2,1} = task(ss).name(nameidx(6)+1:nameidx(7)-1);
            %     taskorder{ss,1} = task(ss).name(nameidx(6)+1:nameidx(7)-1);
            daytime{ss+(jj-1)*2,1} = task(ss).folder(dayidx(end-2)+1:dayidx(end-1)-1);
            twinsNum{ss+(jj-1)*2,1} = task(ss).folder(dayidx(end-1)+1:dayidx(end)-1);
            
            mcoh(ss+(jj-1)*2,1) = mean(coh);
            accuracy(ss+(jj-1)*2,1) = mean(isc);
            
            [~,~,stat] = glmfit(zscore(rtime), zscore(conf));
            fitconf = stat.beta(2)*zscore(rtime);
            [~,~,statorig] = glmfit(rtime, conforig);
            
            [~,~,stathigh] = glmfit([rtime, rtime.^2, rtime.^3, rtime.^4, rtime.^5], conf);
            fitconfhigh = stathigh.beta(1) + sum(stathigh.beta(2:end)' .* [rtime, rtime.^2, rtime.^3, rtime.^4, rtime.^5], 2);
            [~,~,statorighigh] = glmfit([rtime, rtime.^2, rtime.^3, rtime.^4, rtime.^5], conforig);
            
            [~,~,~,myauc(ss+(jj-1)*2,1)] = perfcurve(isc, conf, true);
            [~,~,~,myfitauc(ss+(jj-1)*2,1)] = perfcurve(isc, fitconf, true);
            [~,~,~,myfitauchigh(ss+(jj-1)*2,1)] = perfcurve(isc, fitconfhigh, true);
            [~,~,~,myaucresid(ss+(jj-1)*2,1)] = perfcurve(isc, stat.resid, true);
            [~,~,~,myaucresidhigh(ss+(jj-1)*2,1)] = perfcurve(isc, stathigh.resid, true);
            [~,~,~,otherauc(ss+(jj-1)*2,1)] = perfcurve(isc, conforig, true);
            [~,~,~,otheraucresid(ss+(jj-1)*2,1)] = perfcurve(isc, statorig.resid, true);
            [~,~,~,otheraucresidhigh(ss+(jj-1)*2,1)] = perfcurve(isc, statorighigh.resid, true);
            
            confresidhigh = stathigh.resid;
            rxc_isc_conf = crosstab(isc, confresidhigh>mean(confresidhigh));
            myiscgammahigh(ss+(jj-1)*2,1) = gkgammatst(rxc_isc_conf);
            
            rtweight(ss+(jj-1)*2,1) = stat.beta(2);
            mrtime(ss+(jj-1)*2,1) = mean(rtime);
            varrtime(ss+(jj-1)*2,1) = var(rtime);
            myrtcorr(ss+(jj-1)*2,1) = corr(rtime, conf);
            otherrtcorr(ss+(jj-1)*2,1) = corr(rtime, conforig);
            
            confcorrraw(ss+(jj-1)*2,1) = corr(conf, conforig);
            confcorr_resid(ss+(jj-1)*2,1) = corr(stat.resid, conforig);
            confcorr_residbi(ss+(jj-1)*2,1) = corr(stat.resid, statorig.resid);
            confcorr_residhigh(ss+(jj-1)*2,1) = corr(stathigh.resid, statorighigh.resid);
        end
    end

end
tblguess = table(daytime, twinsNum, myname, othername,...
    mcoh, accuracy, mconf, ...
    mrtime, varrtime, myiscgamma, myiscgammahigh, rtweight, myrtcorr, otherrtcorr,...
    myauc, myfitauc, myfitauchigh, myaucresid, myaucresidhigh, otherauc, otheraucresid, otheraucresidhigh, ...
    confcorrraw, confcorr_resid, confcorr_residbi, confcorr_residhigh);

%%
tblguess = sortrows(tblguess, 'twinsNum');
dstr = datestr(now, 'mmdd-HH;MM;SS');
% writetable(tblguess, [resultfolder, 'Guessin1sessions' dstr '.xlsx'],'FileType','spreadsheet')
writetable(tblguess, [resultfolder, 'Guessin1sessions' dstr '.csv'],'FileType','text')
