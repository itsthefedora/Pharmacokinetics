%%
figure('position', [100 100 1024 600]);

yWeights = [0 0 0 0 1]';

set(gca, 'fontsize', 24);
xlabel('Time (h)');
ylabel('Plasma concentration (uM)');
hold on;
set(gca, 'xlim', [0 24]);

%%

plot(tResult, 1e3 * yResult * yWeights / (molarMassGSH * VdGSH), 'k-', 'linewidth', 2);