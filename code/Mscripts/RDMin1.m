clear; 
home
st = tic;
%% read data
tblraw = readtable('RDMin1sessions0312-19;59;37.xlsx', 'FileType','spreadsheet');
%% exclude data
tbl = tblraw;
aa = find(cellfun(@(x) strcmp(x,'laimiwen'),tbl.myname));
bb = find(cellfun(@(x) strcmp(x,'laimixue'),tbl.myname));
cc = find(cellfun(@(x) strcmp(x,'renchunshan'),tbl.myname));
dd = find(cellfun(@(x) strcmp(x,'renchunshui'),tbl.myname));
ee = find(cellfun(@(x) strcmp(x,'sunfanru'),tbl.myname));
ff = find(cellfun(@(x) strcmp(x,'jiawenbin'),tbl.myname));
jj = find(cellfun(@(x) strcmp(x,'yulikun'),tbl.myname));
tbl([aa;bb;cc;dd;ee;ff;jj],:) = [];
%%
RDMtwins = [tbl.mcoh, tbl.accuracy, tbl.myauc, tbl.ztype];
RDMmz = RDMtwins(RDMtwins(:,end)==1,:);
RDMdz = RDMtwins(RDMtwins(:,end)==2,:);
RDMmzpair_auc = [RDMmz(1:2:end,3),RDMmz(2:2:end,3)];
RDMdzpair_auc = [RDMdz(1:2:end,3),RDMdz(2:2:end,3)];
RDMmzpair_accu = [RDMmz(1:2:end,2),RDMmz(2:2:end,2)];
RDMdzpair_accu = [RDMdz(1:2:end,2),RDMdz(2:2:end,2)];
RDMmzpair_mcoh = [RDMmz(1:2:end,1),RDMmz(2:2:end,1)];
RDMdzpair_mcoh = [RDMdz(1:2:end,1),RDMdz(2:2:end,1)];
%%
csvwrite('mz_auc_in1.csv',RDMmzpair_auc)
csvwrite('dz_auc_in1.csv',RDMdzpair_auc)
csvwrite('dz_accu_in1.csv',RDMdzpair_accu)
csvwrite('mz_accu_in1.csv',RDMmzpair_accu)
csvwrite('dz_mcoh_in1.csv',RDMdzpair_mcoh)
csvwrite('mz_mcoh_in1.csv',RDMmzpair_mcoh)