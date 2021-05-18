%%
clear;home;
tblrdmin1 = readtable('result_files\RDMin1session0801-15;12;34.csv');

%%
tblrdmin1mz = tblrdmin1(tblrdmin1.zyg==1, :);
tblrdmin1dz = tblrdmin1(tblrdmin1.zyg==2, :);

%% only run in first time
% if exist('excelsuborder.mat','file')==2
%     load('excelsuborder.mat')
%     
% else
%     emptable = table(); %%
%     save excelsuborder emptable
% end
% 
% 
% atable = table(table2cell(emptable(1:2:end,1)), table2cell(emptable(2:2:end,1)), table2cell(emptable(1:2:end,2)), table2cell(emptable(2:2:end,2)));
% 
% 
% jj = 1;
% catedsubs = table();
% for ii = 1:height(atable)
%     
%     if ~isequal(atable.Var1{ii}(1:4), tblrdmin1.twinsNum{jj})
%         continue;
%     else
%         % cat same Num sub
%         
%         catedsubs(jj, :) = [tblrdmin1(jj,2:7), atable(ii,:)];
%         jj = min(jj+1, height(tblrdmin1));
%     end
%     
% end
% 
% writetable(catedsubs, 'subsneedswitch.csv', 'FileType','text')

%%
tblSTAImz = readtable('STAIÎÊ¾í.xlsx', 'FileType','spreadsheet','Sheet','mzSTAI');
tblSTAIdz = readtable('STAIÎÊ¾í.xlsx', 'FileType','spreadsheet','Sheet','dzSTAI');

%%
if exist('subsneedswitch.csv','file')==2
    tblswitchtag = readtable('subsneedswitch.csv');
    
end

tblswitchtagmz = tblswitchtag(tblswitchtag.zyg==1, :);
tblswitchtagdz = tblswitchtag(tblswitchtag.zyg==2, :);

tblSTAIordmz = SwitchDataOrder(tblSTAImz, tblswitchtagmz);
tblSTAIorddz = SwitchDataOrder(tblSTAIdz, tblswitchtagdz);

%% correlation 
% if exist('vars_correlation_result.mat','file')==2
%     load('vars_correlation_result.mat')
% end
eraseMZ = FindStrinCell({'T001','T007','T013','T028','T033','T035','T054','T055','T087','T090'}, ... % max ten pairs of MZ auc difference 'T088',
    tblrdmin1mz.twinsNum);
tblrdmin1mz(eraseMZ,:) = [];
tblSTAIordmz(eraseMZ,:) = [];


if isequal(tblrdmin1mz.twinsNum, tblSTAIordmz.mzsub) && isequal(tblrdmin1dz.twinsNum, tblSTAIorddz.dzsub)
    % mcoh, accu, mconf, mrtime, varrtime, rtcorr, auc, aucresid, sai, tai
    varnames =  {'mcoh', 'accu', 'mrtime', 'stdrtime',  'mconf', 'rtcorr', 'auc', 'aucresid'}; %, 'age','sai', 'tai'
    % MZ
%     age = [tblrdmin1mz.age; tblrdmin1mz.age];
    mcoh = [tblrdmin1mz.mcoh1; tblrdmin1mz.mcoh2];
    accu = [tblrdmin1mz.accu1; tblrdmin1mz.accu2];
    mconf = [tblrdmin1mz.mconf1; tblrdmin1mz.mconf2];
    mrtime = [tblrdmin1mz.mrtime1; tblrdmin1mz.mrtime2];
    stdrtime = [tblrdmin1mz.stdrtime1; tblrdmin1mz.stdrtime2];
    rtcorr = [tblrdmin1mz.rtcorr1; tblrdmin1mz.rtcorr2];
    auc = [tblrdmin1mz.auc1; tblrdmin1mz.auc2];
    aucresid = [tblrdmin1mz.aucresid1; tblrdmin1mz.aucresid2];
%     sai = [tblSTAIordmz.SAI_A; tblSTAIordmz.SAI_B];
%     tai = [tblSTAIordmz.TAI_A; tblSTAIordmz.TAI_B];
    
    allvars = [ mcoh, accu, mrtime, stdrtime,  mconf, rtcorr, auc, aucresid]; %, sai, tai age,
    nanrm = any(isnan(allvars(:,end-1:end)),2);
    allvarsclear = allvars(~nanrm, :);
    [mzr, mzp] = corr(allvars);
    [nanmzr, nanmzp] = corr(allvarsclear);
    
    tblmzr = array2table(mzr, 'VariableNames', varnames, 'RowNames', varnames);
    tblmzp = array2table(mzp, 'VariableNames', varnames, 'RowNames', varnames);
    tblnanmzr = array2table(nanmzr, 'VariableNames', varnames, 'RowNames', varnames);
    tblnanmzp = array2table(nanmzp, 'VariableNames', varnames, 'RowNames', varnames);
    % DZ
%     age = [tblrdmin1dz.age; tblrdmin1dz.age];
    mcoh = [tblrdmin1dz.mcoh1; tblrdmin1dz.mcoh2];
    accu = [tblrdmin1dz.accu1; tblrdmin1dz.accu2];
    mconf = [tblrdmin1dz.mconf1; tblrdmin1dz.mconf2];
    mrtime = [tblrdmin1dz.mrtime1; tblrdmin1dz.mrtime2];
    stdrtime = [tblrdmin1dz.stdrtime1; tblrdmin1dz.stdrtime2];
    rtcorr = [tblrdmin1dz.rtcorr1; tblrdmin1dz.rtcorr2];
    auc = [tblrdmin1dz.auc1; tblrdmin1dz.auc2];
    aucresid = [tblrdmin1dz.aucresid1; tblrdmin1dz.aucresid2];
%     sai = [tblSTAIorddz.SAI_A; tblSTAIorddz.SAI_B];
%     tai = [tblSTAIorddz.TAI_A; tblSTAIorddz.TAI_B];
    
    allvars = [mcoh, accu, mrtime, stdrtime,  mconf, rtcorr, auc, aucresid]; %, sai, tai age
    nanrm = any(isnan(allvars(:,end-1:end)),2);
    allvarsclear = allvars(~nanrm, :);
    [dzr, dzp] = corr(allvars);
    [nandzr, nandzp] = corr(allvarsclear);
    
    tbldzr = array2table(dzr, 'VariableNames', varnames, 'RowNames', varnames);
    tbldzp = array2table(dzp, 'VariableNames', varnames, 'RowNames', varnames);
    tblnandzr = array2table(nandzr, 'VariableNames', varnames, 'RowNames', varnames);
    tblnandzp = array2table(nandzp, 'VariableNames', varnames, 'RowNames', varnames);
else
    error('Please Check Sub order!!')
end

%%
save vars_correlation_result

%%
writetable(tblmzr,'correlation_vars.xlsx','FileType','spreadsheet','Sheet','mzr')
writetable(tblmzp,'correlation_vars.xlsx','FileType','spreadsheet','Sheet','mzp')
writetable(tblnanmzr,'correlation_vars.xlsx','FileType','spreadsheet','Sheet','nanmzr')
writetable(tblnanmzp,'correlation_vars.xlsx','FileType','spreadsheet','Sheet','nanmzp')

writetable(tbldzr,'correlation_vars.xlsx','FileType','spreadsheet','Sheet','dzr')
writetable(tbldzp,'correlation_vars.xlsx','FileType','spreadsheet','Sheet','dzp')
writetable(tblnandzr,'correlation_vars.xlsx','FileType','spreadsheet','Sheet','nandzr')
writetable(tblnandzp,'correlation_vars.xlsx','FileType','spreadsheet','Sheet','nandzp')








