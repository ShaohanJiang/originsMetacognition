function resdata = ConvergeTwoSessions(data)

if iscell(data)
    tbldata = cell2table(data);
    resdata = tbldata(1:2:end, :);
else
    data1 = data(1:2:end,:);
    data2 = data(2:2:end, :);
    resdata = mean(data1+data2,2);
end

end