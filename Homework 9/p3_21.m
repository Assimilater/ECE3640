clear all;

% Problem 21
b = [1, 0, -1];
a = [1, 0.9, 0.6, 0.05];

figure(1);
subplot(3, 2, 1);
zplane(b, a);
title('Zero-Pole Plot of H(z)');

subplot(3, 2, 2);
[r, p] = residuez(b, a);
r_amp = abs(r); r_angle = angle(r);
p_amp = abs(p); p_angle = angle(p);
% r =
%    1.5880 - 0.1409i
%    1.5880 + 0.1409i
%   -2.1760 + 0.0000i
% r_amp =
%     1.5942
%     1.5942
%     2.1760
% r_angle =
%    -0.0885
%     0.0885
%     3.1416
% 
% p =
%   -0.4022 + 0.6011i
%   -0.4022 - 0.6011i
%   -0.0956 + 0.0000i
% p_amp =
%     0.7233
%     0.7233
%     0.0956
% p_angle =
%     2.1605
%    -2.1605
%     3.1416

n = 0:29;
h = @(n) ...
    -2.176*(-0.0956).^n + ...
    (2*(1.5942)*(0.7233).^n).*cos(2.1605*n - 0.0885); % n > 0

stem(n, h(n));
title('Impulse response found using residuez and analytic methods');

subplot(3, 2, 3);
h_imp = impz(b, a, 30).';
stem(n, h_imp);
title('Impuse response found using impz');

subplot(3, 2, 4);
h_fil = filter(b, a, [1 zeros(1, 29)]);
stem(n, h_fil);
title('Impulse repsonse found using filter');

subplot(3, 2, 5);
stem(n, h(n) - h_imp);
title('Difference from analytic using impz');

subplot(3, 2, 6);
stem(n, h(n) - h_fil);
title('Difference from analytic using filter');
