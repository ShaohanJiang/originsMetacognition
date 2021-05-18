function [h1, h2] = RmCovarianceGLMtwins(x, y, ord, zyg)

tmptbl = table(ord,zyg,x,y);
mz = tmptbl(tmptbl.zyg==1,:);
dz = tmptbl(tmptbl.zyg==2,:);

mzx = mz.x(:);
mzy = mz.y(:);
[~,~,stat] = glmfit(mzx, mzy);
residtmp = stat.resid;
mz.residtmp = reshape(residtmp,[],2);

dzx = dz.x(:);
dzy = dz.y(:);
[~,~,stat] = glmfit(dzx, dzy);
residtmp = stat.resid;
dz.residtmp = reshape(residtmp,[],2);

all = [mz; dz];
all = sortrows(all, 'ord');

h1 = all.residtmp(:,1);
h2 = all.residtmp(:,2);



end