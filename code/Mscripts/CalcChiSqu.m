function X2 = CalcChiSqu(L0, L1)
% calculate chi-squ for likelihood ratio test
% L0 is base model -2LL£¬ L1 is compared model -2LL
% X2 = -2 * log(L1/L0), IF L0, L1 IS max likelihood
% X2 = L1 - L0, IF L0, L1 is (minus 2* loglikelihood)

if L0>L1
    error('Base Model is Better?')
end

if L1>1 && L2>1
    X2 = L1 - L0;
else
    X2 = -2 * log(L1/L0);
end

end