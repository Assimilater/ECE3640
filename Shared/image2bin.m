function [x] = image2bin(fin, fout)
    % Construct output file name from input
    if (nargin < 2)
        fout = [fin(1:max(strfind(fin, '.'))), 'bin'];
    end
    
    % Path correction
    fin = [pwd,'\',fin];
    fout = [pwd,'\output\',fout];
    fprintf('Input file = %s\n', fin);
    fprintf('Output file = %s\n', fout);
    
    % read the image file
    x = imread(fin);
    
    % determine data dimensions
    [M, N, colors] = size(x); % rows, cols, 3 for color, 1 for grayscale
    
    % Write the header
    % ndim = 2 (image)
    % nchan = colors (RGB = 3, gray-scale = 1)
    % dim0 = M
    % dim1 = N
    % dim2 = 0 (not used for images)
    fid = fopen(fout, 'wb');
    fwrite(fid, [2, colors, M, N, 0], 'int');
    
    % Loop over pixel(i = row, j = col) -> R, G, B
    for i = 1:M
        for j = 1:N
            for k = 1:colors
                fwrite(fid, x(i, j, k), 'float');
            end
        end
    end
    
    % Release the file handler
    fclose(fid);
end
