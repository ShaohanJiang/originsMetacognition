function PlotHist2(dist1, d1, dist2, d2, distcolor)


h = histogram(dist1, d1,  'Normalization','probability',  'EdgeColor','none', 'FaceColor',distcolor(1,:));
hold on; 
h = histogram(dist2, d2 , 'Normalization','probability', 'EdgeColor','none', 'FaceColor',distcolor(2,:));
box off
hold off

end