function corres = SelfBS(voi, titletxt)
% voi is [test, retest]


times = 1e5;
corres = zeros(times,1);


[n, c] = size(voi);

if c~=2
    error('???')
else
    
    for ii = 1:times
        %             for jj = 1:n
        %                 tmp(jj,:) = voi(randperm(n,1), 1:2);
        %
        %             end
        
        tmp = voi(randperm(n, ceil(n*3/4)), :);
        corres(ii) = corr(tmp(:,1), tmp(:,2));
    end
end

tmptxt = sprintf('%s\n meanr= %.3f', titletxt, mean(corres));
figure; histogram(corres, 100)
title(tmptxt);
xlim([0,1])

end