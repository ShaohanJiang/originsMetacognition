%% Simulation for Twins
times = 1e6;
voi = self_auc; % variable of interesting
nsub = length(voi);
%% random select 3/4 subs
corrall = zeros(times,1);
for ii = 1:times
    tmp = voi(randperm(nsub, floor(nsub*3/4)), :);
    corrall(ii) = corr(tmp(:,1), tmp(:,2));
    
end
figure; hist(corrall, 100)

%% randperm 2nd time auc
corrall = zeros(times,1);
for ii = 1:times
    tmp = [voi(:,1), voi(randperm(nsub),2)];
    corrall(ii) = corr(tmp(:,1), tmp(:,2));
    
end
figure; hist(corrall, 100)

%% random select twins auc pairs
corrall = zeros(times,1);
nmz = nsub/2;
tmp = [];
for ii = 1:times
    for jj = 1:nmz
        tmp(jj,:) = [subauc1(jj, randi([1,2])),subauc2(jj, randi([1,2]))];
    end
    corrall(ii) = corr(tmp(:,1), tmp(:,2));
end
figure; hist(corrall, 100)

%% random select auc pairs and random choice subs order
corrall = zeros(times,1);
nmz = nsub/2;
tmp = [];
for ii = 1:times
    for jj = 1:nmz
        if rand<0.5
            tmp(jj,:) = [subauc1(jj, 1), subauc2(jj, 2)];
        else
            tmp(jj,:) = [subauc2(jj, 1), subauc1(jj, 2)];
        end
    end
    corrall(ii) = corr(tmp(:,1), tmp(:,2));
end
figure; hist(corrall, 100)
%% random select auc pair with stranger
corrall = zeros(times,1);
tmp = [];
nmz = nsub/2;
for ii = 1:times
    for jj = 1:nsub
        strangerauc = selfauc_test_retest;
        if jj <=nmz
            strangerauc([jj,jj+nmz],:) = [];
        else
            strangerauc([jj-nmz,jj],:) = [];
        end
        tmp(jj,:) = [selfauc_test_retest(jj, randi([1,2])), strangerauc(randperm(length(strangerauc),1), randi([1,2]))];
    end
    corrall(ii) = corr(tmp(:,1), tmp(:,2));
end
figure; hist(corrall, 100)

%% random select twins auc pairs between mz and dz
corrmz = zeros(times,1);
corrdz = zeros(times,1);
voi = twins_auc;
mz = voi(voi(:,5)==1,1:4);
dz = voi(voi(:,5)==2,1:4);
nmz = length(mz);
ndz = length(dz);

for ii = 1:times
    tmp = [];
    for jj = 1:nmz
        tmp(jj,:) = [mz(jj, randi([1,2])), mz(jj, randi([3,4]))];
    end
    corrmz(ii) = corr(tmp(:,1), tmp(:,2));
end
figure; hist(corrmz, 100)
title('mz twins random auc pair correlation');

for ii = 1:times
    tmp = [];
    for jj = 1:ndz
        tmp(jj,:) = [dz(jj, randi([1,2])), dz(jj, randi([3,4]))];
    end
    corrdz(ii) = corr(tmp(:,1), tmp(:,2));
end
figure; hist(corrdz, 100)
title('dz twins random auc pair correlation');

%% random select twins someone measurement pairs and random twins order between mz and dz
corrmz = zeros(times,1);
corrdz = zeros(times,1);
voi = twins_auc;
mz = voi(voi(:,5)==1,:);
dz = voi(voi(:,5)==2,:);
nmz = length(mz);
ndz = length(dz);

for ii = 1:times
    tmp = [];
    for jj = 1:nmz
        tmp(jj,:) = [mz(jj, randi([1,2])), mz(jj, randi([3,4]))];
        if rand<0.5
            tmp(jj,:) = flip(tmp(jj,:));
        end
    end
    corrmz(ii) = corr(tmp(:,1), tmp(:,2));
end
figure; hist(corrmz, 100)
title('mz twins random mrtime pair correlation');

for ii = 1:times
    tmp = [];
    for jj = 1:ndz
        tmp(jj,:) = [dz(jj, randi([1,2])), dz(jj, randi([3,4]))];
        if rand<0.5
            tmp(jj,:) = flip(tmp(jj,:));
        end
    end
    corrdz(ii) = corr(tmp(:,1), tmp(:,2));
end
figure; hist(corrdz, 100)
title('dz twins random mrtime pair correlation');




