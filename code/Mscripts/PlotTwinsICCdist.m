function PlotTwinsICCdist(dist1, dist2, dist3, dist4, colormds)

figure;
h = histogram(dist1,100,  'EdgeColor','none', 'FaceColor',colormds(1,:));
hold on; 
h = histogram(dist3,100 ,'EdgeColor','none', 'FaceColor',colormds(3,:));
box off
xlim([-0.4,0.6]);ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', -0.4:0.2:0.6, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})
figure;
h = histogram(dist2,100,  'EdgeColor','none', 'FaceColor',colormds(2,:));
hold on; 
h = histogram(dist4,100 ,'EdgeColor','none', 'FaceColor',colormds(3,:));
box off
xlim([-0.4,0.6]);ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', -0.4:0.2:0.6, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})
figure;
h = histogram(dist1,100,  'EdgeColor','none', 'FaceColor',colormds(1,:));
hold on; 
h = histogram(dist2,100 ,'EdgeColor','none', 'FaceColor',colormds(2,:));
box off
xlim([-0.4,0.6]);ylim([0,4000])
set(gca,'YTick',0:1000:4000, 'XTick', -0.4:0.2:0.6, 'LineWidth', 1.4)
set(gca, 'YTickLabel', {}, 'XTickLabel', {})