clear all;

x1 = [1,2,3,4,5];
x2 = [2,-1,1,-1];
y = cconv(x1,x2,5);
X = ifft(fft(x1).*fft(x2, 5));
