tau = 10;
B = 10;
Fs = B;
T = 1/Fs;
n = [0:tau/T]; % for discrete time sampling
fun = @(t) sin(pi*B*t.^2/tau);
xd = fun(n*T);

Fs2 = 20*B;
T2 = 1/Fs2;
t = [0:T2:tau]; % for continuous time sampling
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