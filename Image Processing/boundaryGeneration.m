I = imread('test_images/Longhorn.png');

BW = im2bw(I);
BW = imcomplement(BW);
dim = size(BW);

nominalCamRad = 2.5;

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

imshow(I)
hold on;
plot(boundary(:,2),boundary(:,1),'g','LineWidth',3);
hold off;

aspectRatio = (max(boundary(:,2)) - min(boundary(:,2))) / (max(boundary(:,1)) - min(boundary(:,1)));
normXdelRad = ((boundary(:,2) - min(boundary(:,2)))* aspectRatio / (max(boundary(:,2)) - min(boundary(:,2))))- (.5*aspectRatio);
normYdelRad = ((boundary(:,1) - min(boundary(:,1)))/ (max(boundary(:,1)) - min(boundary(:,1)))) - .5;

dim = size(normXdelRad);

theta = zeros(1,dim(1));
for ii = 1:1:dim(1)
    theta(ii) = (ii-1)*(360/dim(1));
end

figure(1);
plot(theta, normXdelRad)
xlabel('degrees');
ylabel('normalized x radius')
figure(2);
plot(theta, normYdelRad)
xlabel('degrees');
ylabel('normalized y radius')

% convert to cartesian coordinates
xCamRad = nominalCamRad + normXdelRad';
xRad_xPos = xCamRad .* cosd(theta);  
xRad_yPos = xCamRad .* sind(theta);

yCamRad = nominalCamRad + normYdelRad';
yRad_xPos = yCamRad .* cosd(theta);
yRad_yPos = yCamRad .* sind(theta);

figure(3);
plot(xRad_xPos, xRad_yPos);

figure(4);
plot(yRad_xPos, yRad_yPos);

A = [xRad_xPos', xRad_yPos', zeros(length(xRad_xPos), 1)];

save('circle xCam.txt', 'A', '-ascii', '-double', '-tabs')
