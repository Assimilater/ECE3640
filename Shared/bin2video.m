function [] = bin2video(fin, fout)
    % Construct output file name from input
    if (nargin < 2)
        fout = [fin(1:max(strfind(fin, '.'))), 'mp4'];
    end
    
    % Path correction
    fin = [pwd,'output\',fin];
    fout = [pwd,'output\',fout];
    fprintf('Input file = %s\n', fin);
    fprintf('Output file = %s\n', fout);
    
    % Read the header
    % ndim = 3 (video)
    % nchan = colors
    % dim0 = M
    % dim1 = N
    % dim2 = Fs
    fid = fopen(fin, 'rb');
    ndim = fread(fid, 1, 'int');
    colors = fread(fid, 1, 'int');
    M = fread(fid, 1, 'int');
    N = fread(fid, 1, 'int');
    Fs = fread(fid, 1, 'int');
    
    %Write the data
    size_frame = M * N * colors;
    vid = VideoWriter(fout, 'MPEG-4');
    vid.FrameRate = Fs;
    open(vid);
    
    % Matlab is stupid, so we can only do this wacky control structure
    [a, ~] = fread(fid, size_frame, 'float');
    while size(a, 1) ~= 0 % ~=, really?
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
        
        % Matlab is stupid, read the next frame
        [a, ~] = fread(fid, size_frame, 'float');
    end
    
    % Release the file handlers
    fclose(fid);
    close(vid);
end
