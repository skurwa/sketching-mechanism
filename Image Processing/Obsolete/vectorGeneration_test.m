% testing an algorithm to follow the path along an image's edge
% this is a function to implement into the software backend of a drawing mechanism
% by Siddharth Kurwa | Spring 2018 | Robot Mechanism Design

% get test image
I = imread('test_images/longhorn.png');
raw_size = size(I);

% ensure that the image used is 2-dimensional
if length(raw_size) > 2
    I = rgb2gray(I);
end

% use Canny filter to perform edge detection
BW = edge(I,'canny');

% display result of Canny filtering
figure(1);
imshow(BW)
title('Canny Filter');

dim = size(BW);
ctr = 1;

% traverse down the diagonal to find an initial seed
noSeed = true;
i = 1;
j = 1;
while noSeed
    if BW(i,j) ~= 0
        seedX(ctr) = j;
        seedY(ctr) = i;
        noSeed = false;
        ctr = ctr + 1;
    end
    i = i + 1;
    j = j + 1; 
end

disp('CP 1');

% check values of nearest neighbors
layers = 1; % layers of nearest neighbors to check
notStuck = true;
while notStuck  
    notFound = true;
    for shift = 1:1:layers
        % make sure we remain within bounds of image
        if ((ctr + shift) < dim(1)) && ((ctr + shift) < dim(2)) && ((ctr + shift) > 0) && ((ctr - shift) < dim(1)) && ((ctr - shift) < dim(2)) && ((ctr - shift) > 0)
            % up, right
            if notFound && ((ctr + shift) < dim(1)) && ((ctr + shift) < dim(2)) && (BW(seedY(ctr - 1) + shift, seedX(ctr - 1) + shift) ~= 0) && ~((ismember(seedY(ctr - 1) + shift, seedY)) && (ismember(seedX(ctr - 1) + shift, seedX)))  
               seedX(ctr) = seedX(ctr - 1) + j;
               seedY(ctr) = seedY(ctr - 1) + shift;
               ctr = ctr + 1;
               notFound = false;
               disp('up,right')
            end
            % up, left
            if notFound && ((ctr + shift) < dim(1)) && ((ctr - shift) < dim(2)) && (BW(seedY(ctr - 1) + shift, seedX(ctr - 1) - shift) ~= 0) && ~((ismember(seedY(ctr - 1) + shift, seedY)) && (ismember(seedX(ctr - 1) - shift, seedX)))  
               seedX(ctr) = seedX(ctr - 1) - shift;
               seedY(ctr) = seedY(ctr - 1) + shift;
               ctr = ctr + 1;
               notFound = false;
               disp('up,left')
            end
            % up
            if notFound && ((ctr + shift) < dim(1)) && (BW(seedY(ctr - 1) + shift, seedX(ctr - 1)) ~= 0) && ~((ismember(seedY(ctr - 1) + shift, seedY)) && (ismember(seedX(ctr - 1), seedX)))  
               seedX(ctr) = seedX(ctr - 1);
               seedY(ctr) = seedY(ctr - 1) + shift;
               ctr = ctr + 1;
               notFound = false;
               disp('up')
            end
            % right
            if notFound && ((ctr + shift) < dim(2)) && (BW(seedY(ctr - 1), seedX(ctr - 1) + shift) ~= 0) && ~((ismember(seedY(ctr - 1), seedY)) && (ismember(seedX(ctr - 1) + shift, seedX)))  
               seedX(ctr) = seedX(ctr - 1) + shift;
               seedY(ctr) = seedY(ctr - 1);
               ctr = ctr + 1;
               notFound = false;
               disp('right')
            end
            % down, left
            if notFound && ((ctr - shift) < dim(1)) && ((ctr - shift) < dim(2)) && (BW(seedY(ctr - 1) - shift, seedX(ctr - 1) - shift) ~= 0) && ~((ismember(seedY(ctr - 1) - shift, seedY)) && (ismember(seedX(ctr - 1) - shift, seedX)));
               seedX(ctr) = seedX(ctr - 1) - j;
               seedY(ctr) = seedY(ctr - 1) - shift;
               ctr = ctr + 1;
               notFound = false;
               disp('down,left')
            end
            % down, right
            if notFound && ((ctr - shift) < dim(1)) && ((ctr + shift) < dim(2)) && (BW(seedY(ctr - 1) - shift, seedX(ctr - 1) + shift) ~= 0) && ~((ismember(seedY(ctr - 1) - shift, seedY)) && (ismember(seedX(ctr - 1) + shift, seedX)));
               seedX(ctr) = seedX(ctr - 1) + shift;
               seedY(ctr) = seedY(ctr - 1) - shift;
               ctr = ctr + 1;
               notFound = false;
               disp('down,right')
            end
            % down
            if notFound && ((ctr - shift) < dim(1)) && (BW(seedY(ctr - 1) - shift, seedX(ctr - 1)) ~= 0) && ~((ismember(seedY(ctr - 1) - shift, seedY)) && (ismember(seedX(ctr - 1), seedX)));
               seedX(ctr) = seedX(ctr - 1);
               seedY(ctr) = seedY(ctr - 1) - shift;
               ctr = ctr + 1;
               notFound = false;
               disp('down')
            end
            % left
            if notFound && ((ctr - shift) < dim(2)) && (BW(seedY(ctr - 1), seedX(ctr - 1) - shift) ~= 0) && ~((ismember(seedY(ctr - 1), seedY)) && (ismember(seedX(ctr - 1) - shift, seedX)));
               seedX(ctr) = seedX(ctr - 1) - shift;
               seedY(ctr) = seedY(ctr - 1);
               ctr = ctr + 1;
               notFound = false;
               disp('left')
            end
        end
    end
    if (notFound == true)
        disp('Got stuck')
        notStuck = false;
    end
end

figure(2);
plot(seedX, seedY);









            