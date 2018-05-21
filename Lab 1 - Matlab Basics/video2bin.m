function [vid] = video2bin(fin, fout)
    % Construct output file name from input
    if (nargin < 2)
        fout = [fin(1:max(strfind(fin, '.'))), 'bin'];
    end
    
    % Path correction
    fin = [pwd,'\','Resources\',fin];
    fout = [pwd,'\','Output\',fout];
    fprintf('Input file = %s\n', fin);
    fprintf('Output file = %s\n', fout);
    
    % read the video file
    vid = VideoReader(fin);
    frames = vid.NumberOfFrames; % apparently this is deprecated too?! >:|
    M = vid.Height;
    N = vid.Width;
    Fs = vid.FrameRate;
    %colors = vid.BitsPerPixel / 8;
    colors = 3; % we can't store it so we can't support differences here
    %x = read(vid); % read all frames - who cares that this is deprecated
    %[M, N, colors, frames] = size(x);
    
    % Write the header
    % ndim = 3 (video)
    % nchan = Fs
    % dim0 = M
    % dim1 = N
    % dim2 = frames
    fid = fopen(fout, 'wb');
    fwrite(fid, [3, Fs, M, N, frames], 'int');
    
    % Loop over pixel(i = row, j = col) -> R, G, B
    for f = 1:frames
        x = read(vid, f); % Don't care that this is deprecated, matlab sucks
        for i = 1:M
            for j = 1:N
                for k = 1:colors
                    fwrite(fid, x(i, j, k), 'float');
                end
            end
        end
    end
    
    % Release the file handler
    fclose(fid);
end
