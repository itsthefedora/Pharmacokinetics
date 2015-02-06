%%

finalResult = {};
timeResult = {};

%%

finalResult{end+1} = yResult(:, 2);
timeResult{end+1} = tResult;

%%

figure('position', [100 100 1024 600]);
axes;
hold on;
set(gca, 'fontsize', 24);

colors = lines(length(finalResult));

for i = 1:length(finalResult)
    
    plot(timeResult{i}/24, finalResult{i}, 'color', colors(i, :), 'linewidth', 2);
    
end

xlabel('Time (days)');
ylabel('Amount in body (mg)');