function [] = ADC_DAC(f, T, t_max, label)
    % high resolution sampling (kind of continous)
    t = 0:1/100:t_max;
    xt = f(t);
    
    % Get the sampled signal
    %n = 0:1:t_max/T;
    nT = 0:T:t_max; % n.*T;
    xn = f(nT);
    
    % Pass through the ideal DAC
    mysinc = @(t) sinc(t/T);
    xr = zeros(size(t));
    for i = 1:length(xn)
        xr = xr + xn(i)*mysinc(t - nT(i));
    end
    
    %Plot the output
    stem(nT, xn);
    hold on;
    plot(t, xt);
    plot(t, xr, 'k');
    ylabel('x [V]', 'FontSize', 16);
    xlabel('t [s]', 'FontSize', 16);
    title(label, 'FontSize', 22);
    set(gca, 'FontSize', 10);
    xlim([0 t_max]);
    hold off;
    grid on;
end
