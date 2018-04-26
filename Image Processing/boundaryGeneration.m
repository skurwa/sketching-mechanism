clear all;
clc;

filename = 'circle.png';
strcat(filename)

dFollower = 1;

I = imread(strcat('test_images/', filename));

BW = im2bw(I);
BW = imcomplement(BW);
dim = size(BW);

centerCamRad = 2;
singleSideDel = 1;

i = 1; j = 1;
noSeed = true;
while noSeed
    if BW(i,j) ~= 0
        seedX = i;
        seedY = j;
        noSeed = false;
    end
    i = i + 1;
    j = j + 1; 
end

boundary = bwtraceboundary(BW,[seedY,seedX],'E');

figure(1);
imshow(I)
hold on;
plot(boundary(:,2),boundary(:,1),'g','LineWidth',3);
hold off;

aspectRatio = (max(boundary(:,2)) - min(boundary(:,2))) / (max(boundary(:,1)) - min(boundary(:,1)));
if aspectRatio >= 1 % this means that the x distance is larger than the y
    % normalize x distance to range between [-1,1]
    xDelRad = (((boundary(:,2) - min(boundary(:,2))) * 2 * singleSideDel / (max(boundary(:,2)) - min(boundary(:,2))))- singleSideDel);
    % normalize y distance to range between [-1,1] but then also make
    % proportional to x range via the aspect ratio
    yDelRad = (((boundary(:,1) - min(boundary(:,1))) * 2 * singleSideDel / (max(boundary(:,1)) - min(boundary(:,1)))) - singleSideDel)/aspectRatio;
else
    % normalize x distance to range between [-1,1] but then also make
    % proportional to y range via the aspect ratio
    xDelRad = (((boundary(:,2) - min(boundary(:,2)))*2*singleSideDel * aspectRatio / (max(boundary(:,2)) - min(boundary(:,2))))- singleSideDel);
    % normalize y distance to range between [-1,1] 
    yDelRad = (((boundary(:,1) - min(boundary(:,1))) * 2 * singleSideDel / (max(boundary(:,1)) - min(boundary(:,1)))) - singleSideDel);
end

dim = size(xDelRad);

theta = zeros(1,dim(1));
for ii = 1:1:dim(1)
    theta(ii) = (ii-1)*(360/dim(1));
end

figure(2);
subplot(1,2,1);
plot(theta, xDelRad)
xlabel('degrees');
ylabel('delta x cam radius');
title(strcat(filename, '-change in x cam radius vs theta'));
subplot(1,2,2);
plot(theta, yDelRad)
xlabel('degrees');
ylabel('delta y cam radius');
title(strcat(filename, '-change in y cam radius vs theta'));

% convert to cartesian coordinates
%Check with the camPlausibility Function
xCamRad = centerCamRad + xDelRad';
xRad_xPos = xCamRad .* cosd(theta);  
xRad_yPos = xCamRad .* sind(theta);

xRad_xPos = [xRad_xPos, xRad_xPos(1)];
xRad_yPos = [xRad_yPos, xRad_yPos(1)];

%Check with the campPlausibility Function
yCamRad = centerCamRad + yDelRad';
degOffset = 90;
yRad_xPos = yCamRad .* cosd(theta+degOffset);
yRad_yPos = yCamRad .* sind(theta+degOffset);

yRad_xPos = [yRad_xPos, yRad_xPos(1)];
yRad_yPos = [yRad_yPos, yRad_yPos(1)];

% %Check the accuracy and plausibility of each cam shape
% [plausiblex, accuracySumx, missedx, problemsx] = outerCamPlausibility(dFollower, xCamRad, 'X');
% [plausibley, accuracySumy, missedy, problemsy] = outerCamPlausibility(dFollower, yCamRad, 'Y');
% 
figure(3);
subplot(1,2,1);
plot(xRad_xPos, xRad_yPos);
% hold on
% %On top of the cam shape plots, plot an x for any points that make the cam
% %fail, plot a circle for any points that will not be read
% for i = 1:length(xCamRad)
%     if(problemsx(i))
%         scatter(xRad_xPos(i),xRad_yPos(i),'x')
%     end
%     if(missedx(i))
%         scatter(xRad_xPos(i),xRad_yPos(i),'o')
%     end
% end
% hold off
title(strcat(filename, '-xCamShape'));
xlabel('x position (in)');
ylabel('y posiiton (in)');
subplot(1,2,2);
plot(yRad_xPos, yRad_yPos);
% hold on
% %On top of the cam shape plots, plot an x for any points that make the cam
% %fail, plot a circle for any points that will not be read
% for i = 1:length(yCamRad)
%     if(problemsy(i))
%         scatter(yRad_xPos(i),yRad_yPos(i),'x')
%     end
%     if(missedy(i))
%         scatter(yRad_xPos(i),yRad_yPos(i),'o')
%     end
% end
% hold off
title(strcat(filename, '-yCamShape'));
xlabel('x position (in)');
ylabel('y posiiton (in)');

% porting to text file in Solidworks-readable format
xCamShape = [xRad_xPos', xRad_yPos', zeros(length(xRad_xPos), 1)];
yCamShape = [yRad_xPos', yRad_yPos', zeros(length(yRad_xPos), 1)];

save(strcat(filename, '-xCam.txt'), 'xCamShape', '-ascii', '-double', '-tabs')
save(strcat(filename, '-yCam.txt'), 'yCamShape', '-ascii', '-double', '-tabs')