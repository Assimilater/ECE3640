function [nT] = ADC_FT(x, t, T, label)
    % high resolution sampling (kind of continous)
    xc = x(t);
    
    % Get the sampled signal
    nT = min(t):T:max(t);
    xd = x(nT);
    
    % Pass through the ideal DAC
    mysinc = @(t) sinc(t/T);
    xr = zeros(size(t));
    for i = 1:length(xd)
        xr = xr + xd(i)*mysinc(t - nT(i));
    end
    
    %Plot the output
    stem(nT, xd);
    hold on;
    plot(t, xc);
    plot(t, xr, 'k');
    ylabel('x', 'FontSize', 16);
    xlabel('t', 'FontSize', 16);
    title(label, 'FontSize', 22);
    set(gca, 'FontSize', 10);
    hold off;
    grid on;
end
