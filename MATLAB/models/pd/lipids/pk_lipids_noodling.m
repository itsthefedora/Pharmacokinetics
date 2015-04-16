plotIdxFFA = [4 8 14 21];
plotIdxLPL = [17 24];
plotIdxGlu = [5 11 18];
scaleFactorGlu = 100 / 7.24;
plotIdxIns = [9 15 22];
plotIdxSink = [25 26 27];

plotIdx = plotIdxGlu;
scaleFactor = scaleFactorGlu;

figure;
plot( t, scaleFactor * y(:, plotIdx), 'linewidth', 2 );
legend( n(plotIdx) );