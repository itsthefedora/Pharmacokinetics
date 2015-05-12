tFastLast = tFast{end};
yFastLast = yFast{end};

scale = 1;
%scale = 100 / 7.24;

%idx = [2 3 4 5];
%idx = 13;
%idx = [6 14];
idx = [17 24 28 31];
%idx = [18 25];
%idx = [10];

figure('position', [100 100 1024 600]);
plot( tFastLast, scale * yFastLast(:, idx), 'linewidth', 2 );
legend( lFast{idx} )