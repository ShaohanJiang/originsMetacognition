function tblres = SwitchDataOrder(tblSTAI, tbltag)
% tblres 


jj = 1;
STAIfield = tblSTAI.Properties.VariableNames;
tblres = table();
for ii = 1:height(tblSTAI)
    if ~isequal(tblSTAI.(STAIfield{1}){ii}, tbltag.twinsNum{jj})
        continue;
    else
        % cat same Num sub
        if tbltag.sameorder==1
            tblres(jj,:) = [tblSTAI.(STAIfield{1}){ii}, ...
                tblSTAI.(STAIfield{3}){ii}, tblSTAI.(STAIfield{2}){ii}, ...
                tblSTAI.(STAIfield{5}){ii}, tblSTAI.(STAIfield{4}){ii}];
            
            
        else
            tblres(jj,:) = tblSTAI(ii,:);
            
        end
        jj = min(jj+1, height(tbltag));
    end
    
end

% 
if ~isequal(tblSTAI.(STAIfield{1}){ii}, tbltag.twinsNum{jj})
    nmiss = height(tbltag)-jj+1;
    tblres(jj:height(tbltag), :) = table(tbltag.twinsNum(jj:end), nan(nmiss,1), nan(nmiss,1), nan(nmiss,1),nan(nmiss,1));
    
end



end