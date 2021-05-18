function [tbltwins, tblstrangers] = TwinsOrStrangers(tbl, doexport)
% 读取来自 CatRDM2sessionData 中的 tblguess 文件
% 输出两个condition的xlsx文件以及分别的tbl
if nargin<2
    doexport = true;
end
resultfolder = 'result_files';
tbltwins = [];
tblstrangers = [];
%% 找到每一轮来的四个人的名字
%   每一轮有1或2对twins，因此可能有2个名字或4个名字
% alldate = unique(tbl.daytime);
alldate = unique(tbl.twinsNum);
for dd = 1:length(alldate) % 遍历 each twin pair
    tmpidx = cellfun(@(x) isequal(x, alldate{dd}), tbl.twinsNum);
    subtbl = tbl(tmpidx,:);
    thistwinsName = unique(subtbl.myname);
    % 通过twinsNum, myname, othername来判断是guess twins还是guess stranger
    % 分别保存guess twins和guess stranger的数据
    
    for ii = 1:height(subtbl)
        if any(GetCellIndex(thistwinsName, subtbl.othername{ii}))
            tbltwins = [tbltwins; subtbl(ii,:)];
        else
            tblstrangers = [tblstrangers; subtbl(ii,:)];
        end
        
    end
    
    % 区分有2对的情况和只有1对的情况
%     if length(thistwinsName)==2
%         twinsname1 = unique(subtbl.myname(1:4));
%         twinsname2 = unique(subtbl.myname(5:8));
%         for tt = 1:height(subtbl)
%             
%             if any(GetCellIndex(twinsname1, subtbl.myname{tt}))&&any(GetCellIndex(twinsname1, subtbl.othername{tt})) ...
%                     || any(GetCellIndex(twinsname2, subtbl.myname{tt}))&&any(GetCellIndex(twinsname2, subtbl.othername{tt}))
%                 % guess twins
%                 tbltwins = [tbltwins; subtbl(tt,:)];
%             else
%                 % guess stranger
%                 tblstrangers = [tblstrangers; subtbl(tt,:)];
%             end
%         
%         end
%         
%         
%     elseif length(thistwinsName)==1
%         twinsname = unique(subtbl.myname);
%         for tt = 1:height(subtbl)
%             
%             if any(GetCellIndex(twinsname, subtbl.myname{tt}))&&any(GetCellIndex(twinsname, subtbl.othername{tt})) 
%                     
%                 % guess twins
%                 tbltwins = [tbltwins; subtbl(tt,:)];
%             else
%                 % guess stranger
%                 tblstrangers = [tblstrangers; subtbl(tt,:)];
%             end
%         
%         end
%     else
%         error('Twins pairs Num should be 1 or 2!!')
%     end
        
end
tbltwins = sortrows(tbltwins, 'twinsNum');
tblstrangers = sortrows(tblstrangers, 'twinsNum');

%% Export Result
if doexport
    dstr = datestr(now, 'mmdd-HH;MM;SS');
%     writetable(tbltwins, [resultfolder, filesep 'GuessTwinsin1sessions' dstr '.xlsx'],'FileType','spreadsheet')
    writetable(tbltwins, [resultfolder, filesep 'GuessTwinsin1sessions' dstr '.csv'],'FileType','text')
%     writetable(tblstrangers, [resultfolder, filesep 'GuessStrangersin1sessions' dstr '.xlsx'],'FileType','spreadsheet')
    writetable(tblstrangers, [resultfolder, filesep 'GuessStrangersin1sessions' dstr '.csv'],'FileType','text')
end

end % Main Func

function idx = GetCellIndex(cellstr, txtstr)
idx = cellfun(@(x) isequal(x, txtstr), cellstr);

end
