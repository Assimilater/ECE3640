function [vid] = video2bin(fin, fout)
    % Construct output file name from input
    if (nargin < 2)
        fout = [fin(1:max(strfind(fin, '.'))), 'bin'];
    end
    
    % Path correction
    fin = [pwd,'\',fin];
    fout = [pwd, '\output\',fout];
    fprintf('Input file = %s\n', fin);
    fprintf('Output file = %s\n', fout);
    
    % read the video file
    vid = VideoReader(fin);
    M = vid.Height;
    N = vid.Width;
    Fs = vid.FrameRate;
    colors = vid.BitsPerPixel / 8;
    
    % Write the header
    % ndim = 3 (video)
    % nchan = colors
    % dim0 = M
    % dim1 = N
    % dim2 = Fs
    fid = fopen(fout, 'wb');
    fwrite(fid, [3, colors, M, N, Fs], 'int');
    
    % Loop over pixel(i = row, j = col) -> R, G, B
    while hasFrame(vid)
        x = readFrame(vid);
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
