clear all;
B = 10;
T = 10;
x = @(t) sin((pi * B).*(t.^2) / T);

figure(3);
ADC_DAC(x, 1/B, 10, 'Problem 6');
