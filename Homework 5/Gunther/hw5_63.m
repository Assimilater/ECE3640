clear all; clf;
tau = 50;
Fs = 16;
T = 1/Fs;
n = [-tau/T:tau/T]; % for discrete time sampling
fun = @(t) 2*cos(2*pi*5*t-pi/3) - 3*sin(2*pi*8*t);
xd = fun(n*T);

Fs2 = 20*Fs;
T2 = 1/Fs2;
t = [-tau:T2:tau]; % for continuous time sampling
xc = fun(t);

plot(t,xc,'LineWidth',2); hold on;
stem(n*T,xd,'r'); hold off;

mysinc = @(t) sinc(t/T);

xr = zeros(size(t));
for i = 1:length(xd)
    xr = xr + xd(i)*mysinc(t-n(i)*T);
end
hold on;
plot(t,xr,'k');
hold off;
xlim([-0.5,0.5]);
shg