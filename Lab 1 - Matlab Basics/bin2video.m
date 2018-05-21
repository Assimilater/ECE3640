function [fout] = bin2video(fin, fout)
    % Construct output file name from input
    if (nargin < 2)
        fout = [fin(1:max(strfind(fin, '.'))), 'mp4'];
    end
    
    % Path correction
    fin = [pwd,'\','Output\',fin];
    fout = [pwd,'\','Output\',fout];
    fprintf('Input file = %s\n', fin);
    fprintf('Output file = %s\n', fout);
    
    % Read the header
    % ndim = 3 (video)
    % nchan = Fs
    % dim0 = M
    % dim1 = N
    % dim2 = frames
    fid = fopen(fin, 'rb');
    ndim = fread(fid, 1, 'int');
    Fs = fread(fid, 1, 'int');
    M = fread(fid, 1, 'int');
    N = fread(fid, 1, 'int');
    frames = fread(fid, 1, 'int');
    colors = 3; % We can't support gray-scale videos
    
    %Write the data
    size_frame = M * N * colors;
    vid = VideoWriter(fout, 'MPEG-4');
    vid.FrameRate = Fs;
    open(vid);
    
    % Just use nested loops this time
    for f = 1:frames
        % Read frame by frame
        [a, ~] = fread(fid, size_frame, 'float');
        x = zeros(M, N, colors);
        
        for i = 1:M
            for j = 1:N
                for k = 1:colors
                    % 3 dimensional array access with 1-based indexing
                    x(i, j, k) = a(...
                        (i - 1) * N * colors + ...
                        (j - 1) * colors + ...
                        k);
                end
            end
        end
        
        % Convert to uint8 just like images
        x = uint8(x);
        writeVideo(vid, x);
    end
    
    % Release the file handlers
    fclose(fid);
    close(vid);
end
