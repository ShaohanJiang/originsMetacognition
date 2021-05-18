function [ax1, ax2] = PlotQuaHist(bttmdist1, bttmdist2, topdist1, topdist2, facecolor)

if nargin<5
    facecolor = [lines(2); lines(2)];
end
% tmprange = [ceil(max(mztmp)*10)/10-0.4,  ceil(max(mztmp)*10)/10];

histogram(topdist1,100, 'EdgeColor','none', 'FaceColor',facecolor(3,:), 'Normalization', 'probability')
hold on 
histogram(topdist2,100, 'EdgeColor','none', 'FaceColor',facecolor(4,:), 'Normalization', 'probability')
box off

ax1 = gca;
set(ax1,'XAxisLocation','top');
set(ax1,'YDir','reverse');
set(ax1,'YAxisLocation','right');
ylim([0, 0.1]);

% ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','bottom','YAxisLocation','right',...
%     'Color','none', 'XColor','b','YColor','b','YLim',[-5e5,45e5],'YTick',[-5e5:10e5:38e5]); hold on;

ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','bottom','YAxisLocation','left',...
    'Color','none', 'XColor','b','YColor','b'); 
hold on;

histogram(bttmdist1,100, 'EdgeColor','none', 'FaceColor',facecolor(1,:), 'Normalization', 'probability')
hold on 
histogram(bttmdist2,100, 'EdgeColor','none', 'FaceColor',facecolor(2,:), 'Normalization', 'probability')
box off
ylim([0, 0.1]);

end