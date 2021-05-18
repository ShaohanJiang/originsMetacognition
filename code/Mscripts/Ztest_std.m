function [h, p, zstat] = Ztest_std(distsn, distn)

if length(distn) == 1 % one-tail right
    zstat = mean(distsn)/std(distsn);
    h = double(abs(zstat)>1.6449);
    
    p = normcdf(-zstat,0,1);
else % two-tail
    
    zstat = (mean(distsn) - mean(distn))/sqrt(var(distsn)+var(distsn));
    h = double(abs(zstat)>1.96);
    
    p = 2 * normcdf(-abs(zstat),0,1);
end




end