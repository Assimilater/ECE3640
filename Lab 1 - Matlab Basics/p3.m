% Parse the data
[vid] = video2bin('xylophone.mp4');

% Read formatted data
[file] = bin2video('xylophone.bin');
implay(file)
