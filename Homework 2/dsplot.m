function [] = dsplot(f, name, haxis, vaxis)
    stem(0:size(f) - 1, f);
    
    if nargin > 1
        title(name);
    end
    if nargin > 2
        xlabel(haxis, 'FontSize', 18);
    end
    if nargin > 3
        ylabel(vaxis, 'FontSize', 18);
    end
    
    set(gca, 'FontSize', 16);
    grid on;
end
