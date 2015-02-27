%%

figure('position', [100 100 1024 600]);
axes; hold on;

for i = 3

    curtf = tf{i};
    curyf = yf{i};
    plot(curtf, 100*curyf(:, 3)/7.24, 'k-', 'linewidth', 2);
    
end

%set(gca, 'xlim', [24*2 24*3])

%%

f = pk_tanh_sd_flow( (qGlut4TFMax - qGlut4TFBase), -glut4TFShape, glut4TFCenter );
for i = 1:length(x)
y(i) = f(0,x(i));
end

plot(x,y)