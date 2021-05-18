function corres = TwinsBootstrapGLM(indep, voi, isstranger, titletxt)
% voi is twin pairs
% voi less than 4 coloumns use 3/4 bootstrap, otherwise use random pair
% correlation. 
times = 1e5;
corres = zeros(times,1);


[n, c] = size(voi);
if ~isstranger
    if c>4
        for ii = 1:times
            tmp = [];
            for jj = 1:n
                cc = randperm(n,1);
                tmp(jj,:) = [voi(cc, randi([1,2])), voi(cc, randi([3,4]))];
                tmpindep(jj,:) = [indep(cc, randi([1,2])), indep(cc, randi([3,4]))];
%                 tmp(jj,:) = [voi(jj, randi([1,2])), voi(jj, randi([3,4]))];
                if rand<0.5
                    tmp(jj,:) = flip(tmp(jj,:));
                    tmpindep(jj,:) = flip(tmpindep(jj,:));
                end
            end
            alltmpindep = [tmpindep(:,1); tmpindep(:,2)];
            alltmp = [tmp(:,1); tmp(:,2)];
            [~,~,stat] = glmfit(alltmpindep, alltmp);
%             [~,~,stat1] = glmfit(tmpindep(:,1), tmp(:,1));
%             [~,~,stat2] = glmfit(tmpindep(:,2), tmp(:,2));
            npair = length(tmp); 
            tmpresid = [stat.resid(1:npair), stat.resid(npair+1:end)];
            corres(ii) = corr(tmpresid(:,1), tmpresid(:,2));
        end
    else
        for ii = 1:times
            for jj = 1:n
                tmp(jj,:) = voi(randperm(n,1), :);

            end
%             tmp = voi(randperm(n, ceil(n*3/4)), :);
            corres(ii) = corr(tmp(:,1), tmp(:,2));
            
        end
    end
else % bootstrap for correlation with strangers
    if c>4
        nsub = n*2;
        for ii = 1:times
            tmp = [];
            for jj = 1:nsub
                strangerauc = voi;
                if jj <=n
                    strangerauc(jj,:) = [];
                    tmp(jj,:) = [voi(jj, randi([1,2])), strangerauc(randperm(length(strangerauc),1), randi([1,4]))];
                else
                    strangerauc(jj-n,:) = [];
                    tmp(jj,:) = [voi(jj-n, randi([3,4])), strangerauc(randperm(length(strangerauc),1), randi([1,4]))];
                end
                
            end
            corres(ii) = corr(tmp(:,1), tmp(:,2));
        end
    else % test retest only 2 coloumns
        nsub = n*2;
        for ii = 1:times
            tmp = [];
            for jj = 1:nsub
                strangerauc = voi;
                if jj <=n
                    strangerauc(jj,:) = [];
                    tmp(jj,:) = [voi(jj, 1), strangerauc(randperm(length(strangerauc),1), randi([1,2]))];
                else
                    strangerauc(jj-n,:) = [];
                    tmp(jj,:) = [voi(jj-n, 2), strangerauc(randperm(length(strangerauc),1), randi([1,2]))];
                end
                
            end
            corres(ii) = corr(tmp(:,1), tmp(:,2));
        end
    end
end

figure; hist(corres, 100)
title(titletxt);


end