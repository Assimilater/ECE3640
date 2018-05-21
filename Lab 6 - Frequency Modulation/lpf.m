function [h] = lpf(D, L)
    fpass = 0.97/(2*D);
    fstop = 1.03/(2*D);
    f1 = (fstop + fpass)/2;
    f2 = (fstop - fpass)/2;
    n = (-L:L).';
    h = (1/D)*sinc(2*f1*n).*sinc(2*f2*n);
end
