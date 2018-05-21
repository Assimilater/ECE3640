clear all;
x = @(t) 2.*cos((10*pi).*t - (pi/3)) - 3.*sin((16*pi).*t);

figure(2);
subplot(3, 1, 1);
ADC_DAC(x, .05, 2, 'Part A');

subplot(3, 1, 2);
ADC_DAC(x, 0.1, 2, 'Part B');

subplot(3, 1, 3);
ADC_DAC(x, 0.5, 2, 'Part C');
