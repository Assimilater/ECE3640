function [x] = bin2image(fin, fout)
    % Construct output file name from input
    if (nargin < 2)
        fout = [fin(1:max(strfind(fin, '.'))), 'png'];
    end
    
    % Path correction
    fin = [pwd,'\','Output\',fin];
    fout = [pwd,'\','Output\',fout];
    fprintf('Input file = %s\n', fin);
    fprintf('Output file = %s\n', fout);
    
    % Read the header
    % ndim = 2 (image)
    % nchan = colors (RGB = 3, gray-scale = 1)
    % dim0 = M
    % dim1 = N
    % dim2 = 0 (not used for images)
    fid = fopen(fin, 'rb');
    ndim = fread(fid, 1, 'int');
    colors = fread(fid, 1, 'int');
    M = fread(fid, 1, 'int');
    N = fread(fid, 1, 'int');
    dim2 = fread(fid, 1, 'int');
    
    % Read the data
    [a, ~] = fread(fid, inf, 'float');
    
    % Release the file handler
    fclose(fid);
    
    % Just use nested loops this time
    x = zeros(M, N, colors);
    for i = 1:M
        for j = 1:N
            for k = 1:colors
                % 3 dimensional array access with 1-based indexing
                x(i, j, k) = a((i - 1)*N*colors + (j - 1)*colors + k);
            end
        end
    end
    
    % Because imwrite is stupid, and requires type uint8
    x = uint8(x);
    
    % Write out the data
    imwrite(x, fout, 'png');
end
