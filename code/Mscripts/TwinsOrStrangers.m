function [tbltwins, tblstrangers] = TwinsOrStrangers(tbl, doexport)
% ��ȡ���� CatRDM2sessionData �е� tblguess �ļ�
% �������condition��xlsx�ļ��Լ��ֱ��tbl
if nargin<2
    doexport = true;
end
resultfolder = 'result_files';
tbltwins = [];
tblstrangers = [];
%% �ҵ�ÿһ�������ĸ��˵�����
%   ÿһ����1��2��twins����˿�����2�����ֻ�4������
% alldate = unique(tbl.daytime);
alldate = unique(tbl.twinsNum);
for dd = 1:length(alldate) % ���� each twin pair
    tmpidx = cellfun(@(x) isequal(x, alldate{dd}), tbl.twinsNum);
    subtbl = tbl(tmpidx,:);
    thistwinsName = unique(subtbl.myname);
    % ͨ��twinsNum, myname, othername���ж���guess twins����guess stranger
    % �ֱ𱣴�guess twins��guess stranger������
    
    for ii = 1:height(subtbl)
        if any(GetCellIndex(thistwinsName, subtbl.othername{ii}))
            tbltwins = [tbltwins; subtbl(ii,:)];
        else
            tblstrangers = [tblstrangers; subtbl(ii,:)];
        end
        
    end
    
    % ������2�Ե������ֻ��1�Ե����
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
