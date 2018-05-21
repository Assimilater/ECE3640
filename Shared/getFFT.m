function [freq, F, phase, mag, db] = getFFT(f, size, scale)
    if nargin == 2
        scale = 1;
    end
    NFFT = 2 ^ size;
    freq = (((0:NFFT-1)/NFFT) - 0.5) * scale;
    F = fftshift(fft(f, NFFT));
    phase = angle(F);
    mag = abs(F);
    db = 20*log10(mag);
end
