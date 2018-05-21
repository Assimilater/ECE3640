function [h] = lpf_resamp(U, D)
    N = max([U D]);
    fpass = 0.9/(2*N);
    fstop = 1.1/(2*N);
    f1 = (fstop + fpass)/2;
    f2 = (fstop - fpass)/2;
    L = 100;
    n = (-L:L).';
    h = (1/N)*sinc(2*f1*n).*sinc(2*f2*n);
    
    % Write out the filter file
    file = sprintf('output\\lpf_%d.bin', N);
    fid = fopen(file, 'wb');
    fwrite(fid, [1 1 length(h) 1 0], 'int');
    fwrite(fid, h, 'float');
    fclose(fid);
end
