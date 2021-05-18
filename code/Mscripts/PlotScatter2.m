function res = PlotScatter2(mzx, mzy, dzx, dzy, titletxt)
% plot scatter fig for tow vector data with same length
% also plot the linear regression line

if nargin<5
    titletxt = 'Please enter the title!';
end

colormd = lines(2);
[res.mzr, res.mzp ]= corr(mzx, mzy);
[res.dzr, res.dzp ] = corr(dzx, dzy);
% txt = sprintf('%s\nr=%.2f, p=%.2f',titletxt, r,p);
% figure;
scatter(mzx, mzy, 12, colormd(1,:), 'filled')
hold on
pfmz=polyfit(mzx,mzy,1);
x1=-1:0.1:1;
y1=polyval(pfmz,x1);
plot(x1,y1, 'k-', 'linewidth',1.3,'Color',colormd(1,:))

hold on
scatter(dzx, dzy, 12, colormd(2,:), 'filled')
hold on
pfdz=polyfit(dzx,dzy,1);
x1=-1:0.1:1;
y1=polyval(pfdz,x1);
plot(x1,y1, 'k-', 'linewidth',1.3,'Color',colormd(2,:))



title(titletxt)

end