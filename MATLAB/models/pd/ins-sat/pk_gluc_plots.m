%%

figure('position', [100 100 1024 600]);

%%

subplotVec = 211;

%idxInterest = [13 14 15]; prefLoc = 'east'; scaleFactor = 1; xl = [min(t) max(t)];
idxInterest = [3 7 10]; prefLoc = 'northwest'; scaleFactor = 100 / 7.24;
%idxInterest = [5 8 11]; prefLoc = 'east'; scaleFactor = 1e12 / (molarMassIns * VdIns);
%idxInterest = [6 9 12]; prefLoc = 'east'; scaleFactor = 1;

xl = [63.9 66.5]; 

subplot(subplotVec)

plot(t, scaleFactor * y(:, idxInterest), 'linewidth', 3);
legend(n(idxInterest), 'location', prefLoc);

set(gca, 'xlim', xl);
set(gca, 'fontsize', 24);
