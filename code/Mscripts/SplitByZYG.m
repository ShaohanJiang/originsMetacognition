%%
clear;home
%%
% tblrdmlast = readtable('D:\Documents\ScriptR\RDMtrainin1_lastsess.csv');
% tblrdm1st = readtable('D:\Documents\ScriptR\RDMtrainin1_firstsess.csv');
% tblrdm2nd = readtable('D:\Documents\ScriptR\RDMtrainin1_secondsess.csv');
tblrdmofficial = readtable('result_files\RDMin1session0423-23;18;43.csv');
tblrdmallavg = readtable('result_files\RDMallin1session0407-23;50;56.csv');
%%
tblrdmtmp = tblrdmofficial;
tblrdmmz = tblrdmtmp(tblrdmtmp.zyg==1, :);
% tblrdmmz(tblrdmmz.nmissing1>=30|tblrdmmz.nmissing2>=30, :)=[];
% tblrdmmz([1,2], :)=[];
rdmmzm = tblrdmmz(tblrdmmz.ismale==1,:);
rdmmzf = tblrdmmz(tblrdmmz.ismale==0,:);

tblrdmdz = tblrdmtmp(tblrdmtmp.zyg==2, :);
% tblrdmdz(tblrdmdz.nmissing1>=30|tblrdmdz.nmissing2>=30, :)=[];
% tblrdmdz([1,2], :)=[];
rdmdzm = tblrdmdz(tblrdmdz.ismale==1,:);
rdmdzf = tblrdmdz(tblrdmdz.ismale==0,:);
%%
% r = [ICC([tblrdmmz.auc1, tblrdmmz.auc2], '1-1'), ICC([tblrdmdz.auc1, tblrdmdz.auc2], '1-1'), ...
% ICC([tblrdmmz.accu1, tblrdmmz.accu2], '1-1'), ICC([tblrdmdz.accu1, tblrdmdz.accu2], '1-1'),...
% ICC([tblrdmmz.mcoh1, tblrdmmz.mcoh2], '1-1'), ICC([tblrdmdz.mcoh1, tblrdmdz.mcoh2], '1-1')];

rgender_auc = [ICC([rdmmzm.auc1, rdmmzm.auc2], '1-1'), ICC([rdmmzf.auc1, rdmmzf.auc2], '1-1'), ...
ICC([rdmdzm.auc1, rdmdzm.auc2], '1-1'), ICC([rdmdzf.accu1, rdmdzf.accu2], '1-1')];

rgender_accu = [ICC([rdmmzm.accu1, rdmmzm.accu2], '1-1'), ICC([rdmmzf.accu1, rdmmzf.accu2], '1-1'), ...
ICC([rdmdzm.accu1, rdmdzm.accu2], '1-1'), ICC([rdmdzf.accu1, rdmdzf.accu2], '1-1')];

rgender_mcoh = [ICC([rdmmzm.mcoh1, rdmmzm.mcoh2], '1-1'), ICC([rdmmzf.mcoh1, rdmmzf.mcoh2], '1-1'), ...
ICC([rdmdzm.mcoh1, rdmdzm.mcoh2], '1-1'), ICC([rdmdzf.mcoh1, rdmdzf.mcoh2], '1-1')];


%%
mzMauc = mean([tblrdmmz.auc1; tblrdmmz.auc2]);
dzMauc = mean([tblrdmdz.auc1; tblrdmdz.auc2]);

mzHighauc_accu = [tblrdmmz.accu1(tblrdmmz.auc1>=mzMauc); tblrdmmz.accu2(tblrdmmz.auc2>=mzMauc)];
mzHighauc_mcoh = [tblrdmmz.mcoh1(tblrdmmz.auc1>=mzMauc); tblrdmmz.mcoh2(tblrdmmz.auc2>=mzMauc)];
mzHighauc_auc = [tblrdmmz.auc1(tblrdmmz.auc1>=mzMauc); tblrdmmz.auc2(tblrdmmz.auc2>=mzMauc)];
mzLowauc_accu = [tblrdmmz.accu1(tblrdmmz.auc1<mzMauc); tblrdmmz.accu2(tblrdmmz.auc2<mzMauc)];
mzLowauc_mcoh = [tblrdmmz.mcoh1(tblrdmmz.auc1<mzMauc); tblrdmmz.mcoh2(tblrdmmz.auc2<mzMauc)];
mzLowauc_auc = [tblrdmmz.auc1(tblrdmmz.auc1<mzMauc); tblrdmmz.auc2(tblrdmmz.auc2<mzMauc)];

corr([mzHighauc_auc, mzHighauc_accu, mzHighauc_mcoh])
corr([mzLowauc_auc, mzLowauc_accu, mzLowauc_mcoh])

dzHighauc_accu = [tblrdmdz.accu1(tblrdmdz.auc1>=mzMauc); tblrdmdz.accu2(tblrdmdz.auc2>=mzMauc)];
dzHighauc_mcoh = [tblrdmdz.mcoh1(tblrdmdz.auc1>=mzMauc); tblrdmdz.mcoh2(tblrdmdz.auc2>=mzMauc)];
dzHighauc_auc = [tblrdmdz.auc1(tblrdmdz.auc1>=mzMauc); tblrdmdz.auc2(tblrdmdz.auc2>=mzMauc)];
dzLowauc_accu = [tblrdmdz.accu1(tblrdmdz.auc1<mzMauc); tblrdmdz.accu2(tblrdmdz.auc2<mzMauc)];
dzLowauc_mcoh = [tblrdmdz.mcoh1(tblrdmdz.auc1<mzMauc); tblrdmdz.mcoh2(tblrdmdz.auc2<mzMauc)];
dzLowauc_auc = [tblrdmdz.auc1(tblrdmdz.auc1<mzMauc); tblrdmdz.auc2(tblrdmdz.auc2<mzMauc)];
corr([dzHighauc_auc, dzHighauc_accu, dzHighauc_mcoh])
corr([dzLowauc_auc, dzLowauc_accu, dzLowauc_mcoh])

%%
voi = [tblrdmmz.auc1, tblrdmmz.auc2]; % [auc1, auc2]
icc_voi = ICC(voi,'1-1');
mvoi = mean(mean(voi));
lenvoi = length(voi);
tmpnum = voi>=mvoi;
numpair = sum(tmpnum(:,1)~=tmpnum(:,2));
% voi = mapminmax(voi(:)',0,1);
% voi = reshape(voi,lenvoi,2); % normalize
txt = sprintf('MZ auc distribution in twins\n\t ICC= %.3f meanauc= %.3f betweenPairs= %d',icc_voi, mvoi, numpair);
figure;
for ii = 1:lenvoi
    plot(ii, voi(ii,1),'o')
    hold on
    plot(ii, voi(ii,2),'o')
    hold on
    plot([ii,ii],[voi(ii,1),voi(ii,2)],'k-')
    hold on
end
ylim([0,1])
title(txt)
hold on
plot([1,lenvoi], [mvoi, mvoi], '--')
%%
diffmz = abs(tblrdmmz.auc1 - tblrdmmz.auc2);
diffdz = abs(tblrdmdz.auc1 - tblrdmdz.auc2);
figure;
plot(ones(length(diffmz),1), diffmz, 'o')
hold on
plot(1.5*ones(length(diffdz),1), diffdz, '*')
xlim([0.5,2])
title('AUC absolute difference')
legend('MZ AUC','DZ AUC')


%%




%%
% mzaccu = [tblrdmmz.accu1; tblrdmmz.accu2];
% mzauc = [tblrdmmz.auc1; tblrdmmz.auc2];
% mzmcoh = [tblrdmmz.mcoh1; tblrdmmz.mcoh2];
% ind = [mzaccu, mzaccu.^2, mzaccu.^3, mzaccu.^4, mzaccu.^5, ...
%     ];
% [~,~,stats] = glmfit(ind, mzauc);
% 
% mzaucresid = reshape(stats.resid, [],2);
% 
% dzaccu = [tblrdmdz.accu1; tblrdmdz.accu2];
% dzauc = [tblrdmdz.auc1; tblrdmdz.auc2];
% dzmcoh = [tblrdmdz.mcoh1; tblrdmdz.mcoh2];
% [~,~,stats] = glmfit([dzaccu, dzaccu.^2, dzaccu.^3, dzaccu.^4, dzaccu.^5], dzauc);
% 
% dzaucresid = reshape(stats.resid, [],2);

%%
% accu = {mzaccu, dzaccu};
% mcoh = {mzmcoh, dzmcoh};
% auc = {mzauc, dzauc};
% G = cat(1, accu, mcoh, auc);
% G = cat(1, mzaccu, dzaccu, mzauc, dzauc);
% class = {'accu', 'mcoh', 'auc'};
% class = [repmat({'mzaccu'}, length(mzaccu),1); repmat({'dzaccu'}, length(dzaccu),1);...
%     repmat({'mzmcoh'}, length(mzmcoh),1);repmat({'dzmcoh'}, length(dzmcoh),1);...
%     repmat({'mzauc'}, length(mzauc),1);repmat({'dzauc'}, length(dzauc),1)];
% positions = [1,1.25, 2, 2.25];
% figure;
% boxplot(G, class, 'Positions', positions)

% G = cat(1, mzmcoh, dzmcoh);
% class = {'accu', 'mcoh', 'auc'};
% class = [repmat({'mzmcoh'}, length(mzmcoh),1);repmat({'dzmcoh'}, length(dzmcoh),1)];
% positions = [1,1.5];
% figure;
% boxplot(G, class, 'Positions', positions)




