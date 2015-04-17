plotIdxFFA = [4 8 15 22];
plotIdxLPL = [11 18 25];
plotIdxGlu = [5 12 19];
scaleFactorGlu = 100 / 7.24;
plotIdxIns = [9 16 23];
plotIdxSink = [26 27 28];

plotIdx = plotIdxLPL;
scaleFactor = 1;

figure;
plot( t, scaleFactor * y(:, plotIdx), 'linewidth', 2 );
legend( n(plotIdx) );