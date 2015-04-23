plotIdxFFA = [4 8 15 22];
plotIdxLPL = [11 18 25];
plotIdxGlu = [5 12 19];
scaleFactorGlu = 100 / 7.24;
plotIdxIns = [9 16 23];
molarMassIns = 5808;
VdIns   = 15.6;
scaleFactorIns = 1e12 / (molarMassIns * VdIns);
plotIdxSink = [26 27 28];

plotIdx1 = plotIdxGlu;
scaleFactor1 = scaleFactorGlu;
plotIdx2 = plotIdxSink;
scaleFactor2 = 1;

%%

figure('position', [100 100 1024 600]);
plot( t, scaleFactor2 * y(:, plotIdx2), 'linewidth', 2 );
set(gca, 'fontsize', 24);
legend( n(plotIdx2), 'fontsize', 16, 'location', 'nw' );
set(gca, 'xlim', [min(t), max(t)]);

%%

figure('position', [100 100 1024 800]);
subplot(211);
plot( t, scaleFactor1 * y(:, plotIdx1), 'linewidth', 2 );
set(gca, 'fontsize', 24);
legend( n(plotIdx1), 'fontsize', 16 );
set(gca, 'xlim', [5*24, 7*24]);

subplot(212);
plot( t, scaleFactor2 * y(:, plotIdx2), 'linewidth', 2 );
set(gca, 'fontsize', 24);
legend( n(plotIdx1), 'fontsize', 16 );
set(gca, 'xlim', [5*24, 7*24]);