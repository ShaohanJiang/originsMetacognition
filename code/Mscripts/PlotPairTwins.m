function [icc_voi, lenvoi] = PlotPairTwins(voi1, voi2)
if nargin < 2
    voi2 = [];
end
% voi1 = twinsaucrawmz; % [auc1, auc2]
icc_voi = ICC(voi1,'1-1');
mvoi = mean(mean(voi1));
% diffvoi = max(voi,[],2) -  min(voi,[],2);
lenvoi = length(voi1);
tmpnum = voi1>=mvoi;
numpair = sum(tmpnum(:,1)~=tmpnum(:,2));
% voi = mapminmax(voi(:)',0,1);
% voi = reshape(voi,lenvoi,2); % normalize
% txt1 = sprintf('AUC distribution \n MZtwins ICC= %.3f',icc_voi);
figure;
for ii = 1:lenvoi
    plot(ii, voi1(ii,1),'ro')
    hold on
    plot(ii, voi1(ii,2),'ro')
    hold on
    plot([ii,ii],[voi1(ii,1), voi1(ii,2)],'r-')
    hold on
end

if ~isempty(voi2)
    % voi2 = strangersaucrawmz; % [auc1, auc2]
    icc_voi(2) = ICC(voi2,'1-1');
    mvoi = mean(mean(voi2));
    % diffvoi = max(voi,[],2) -  min(voi,[],2);
    lenvoi = length(voi2);
    tmpnum = voi2>=mvoi;
    numpair = sum(tmpnum(:,1)~=tmpnum(:,2));
    % voi = mapminmax(voi(:)',0,1);
    % voi = reshape(voi,lenvoi,2); % normalize
    % txt2 = sprintf('   MZstrangers ICC= %.3f',icc_voi);
    % figure;
    for ii = 1:lenvoi
        plot(ii, voi2(ii,1),'bo')
        hold on
        plot(ii, voi2(ii,2),'bo')
        hold on
        plot([ii,ii],[voi2(ii,1),voi2(ii,2)],'b-')
        hold on
    end
end
% ylim([0,1])
% title([txt1, txt2])
% hold on
% plot(Cdistmz, 'm--')
% atmp = sortrows(Cdistmzrtweight,-1);
% hold on
% plot([1,lenvoi], [atmp(11), atmp(11)], 'k--')
% hold on
% plot([1,lenvoi], [0.5, 0.5], 'k--')