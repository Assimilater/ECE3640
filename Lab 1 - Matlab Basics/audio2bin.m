function [x, Fs] = audio2bin(fin, fout)
    % Construct output file name from input
    if (nargin < 2)
        fout = [fin(1:max(strfind(fin, '.'))), 'bin'];
    end
    
    % Path correction
    fin = [pwd,'\','Resources\',fin];
    fout = [pwd,'\','Output\',fout];
    fprintf('Input file = %s\n', fin);
    fprintf('Output file = %s\n', fout);
    
    % Read the audio file
    [x, Fs] = audioread(fin);
    fid = fopen(fout, 'wb');
    
    % Determine data dimensions
    channels = size(x, 2); % columns in x (size of second dimension)
    samples = size(x, 1); % rows in x
    
    % Write the header
    % ndim = 1 (audio)
    % nchan = channels
    % dim0 = samples
    % dim1 = Fs (for audio files)
    % dim2 = 0 (not used for audio)
    fwrite(fid, [1, channels, samples, Fs, 0], 'int');
    
    % Arrange channels by row so the (:) will coalesce correctly
    %transpose = x.';
    
    % Output the data
    %fwrite(fid, transpose(:), 'float');
    
    % Alternatively, use a simple for loop (so what, it's not efficient?)
    for i = 1:samples
        for j = 1:channels
            fwrite(fid, x(i, j), 'float');
        end
    end
    
    % Release the file handler
    fclose(fid);
end
