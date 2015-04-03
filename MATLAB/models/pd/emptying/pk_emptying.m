aFacts = [0:0.25:1 2:10];
doseGlu = 100;
gluLoss = zeros(size(aFacts));

% TODO: Temp

VgiDot = .188 * 1e-3 * 60;    % L / min
Vgi     = 0.105;				% L
VgiFracUpper = 0.1;
VgiUpper = VgiFracUpper * Vgi;
VgiLower = (1 - VgiFracUpper) * Vgi;
kTransUpper = VgiDot / VgiUpper;
kTransLower = VgiDot / VgiLower;

[ iniFN, iniPath ] = uigetfile( 'pk_ini_*.m' );
iniFullPath = fullfile( iniPath, iniFN );

for i = 1:length(aFacts)
    
    ps = {};
    ps.absorptionFactor = aFacts(i);
    ps.doseGlu = doseGlu;
    
    [t, y, n] = pk_main(false, iniFullPath, ps);
    disp(i);
    
    gluLoss(i) = trapz(t, kTransLower * y(:, 2));
    
end

%%

figure('position', [100 100 1024 600]);
plot(aFacts, 1 - ((1/doseGlu) * gluLoss), 'k', 'linewidth', 3);
hold on;
plot([1 1], [0 1], 'k--', 'linewidth', 2);
set(gca, 'fontsize', 24);

xlabel('Absorption rate (times "normal")');
ylabel('Glucose retention (fraction)');

set(gca, 'ylim', [0 1]);