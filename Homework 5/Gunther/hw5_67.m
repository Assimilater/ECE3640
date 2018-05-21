Fs = 1000;
T = 1/Fs;

figure(1);
% Sample
t = [-5e-3:1e-5:5e-3];
xc = exp(-1000*abs(t));
plot(t,xc); hold on;
n = [-5e-3:1/Fs:5e-3];
xd = exp(-1000*abs(n));
stem(n,xd,'r'); hold off;
xlabel('Time [seconds]');
% Reconstruction
hold on;
xr = zeros(size(t));
for i=1:length(xd)
    xr = xr + xd(i)*sinc(Fs*(t-n(i)));
    plot(t,xd(i)*sinc(Fs*(t-n(i))),'m');
end
plot(t,xr,'k');
hold off;

figure(2);
Xc = @(F) 0.002./(1+(0.002*pi*F).^2);
F = [-10000:10000];
Xd = zeros(size(F));
for i=-10:10
    temp = Fs*Xc(F-i*Fs);
    Xd = Xd + temp;
    if(i==0)
    plot(F,temp,'r','LineWidth',5); hold on;
    else
    plot(F,temp,'r'); hold on;
    end
end
plot(F,Xd,'b'); hold off;
xlabel('Frequency [Hz]');