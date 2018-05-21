function [] = plot_spectrogram(f, size, Fs)
    NFFT = 2^size;
    spectrogram(f, hamming(NFFT), round(0.8*NFFT), NFFT, Fs, 'yaxis');
end

