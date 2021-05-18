function res = BsTest2(dist1, dist2)
% Return the percentile of means in another distribution
%

m1 = mean(dist1);
m2 = mean(dist2);


if m1 > m2

    res(1) = mean(dist2>m1); % how many data is great than the higher mean
    res(2) = mean(dist1<m2); % how many data is less than the lower mean

elseif m1 <= m2
    
    res(1) = mean(dist2<m1); 
    res(2) = mean(dist1>m2); 
end


end