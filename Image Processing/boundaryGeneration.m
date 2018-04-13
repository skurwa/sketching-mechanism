I = imread('test_images/circle.png');

BW = im2bw(I);
BW = imcomplement(BW);
dim = size(BW);

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

normXRad = boundary(:,2) / max(boundary(:,2));
normYRad = boundary(:,1) / max(boundary(:,1));

dim = size(normXRad);

theta = zeros(1,dim(1));
for ii = 1:1:dim(1)
    theta(ii) = (ii-1)*(360/dim(1));
end



figure(1);
plot(theta, normXRad)
xlabel('degrees');
ylabel('normalized x radius')
figure(2);
plot(theta, normYRad)
xlabel('degrees');
ylabel('normalized y radius')

% convert to cartesian coordinates
xRad_xPos = normXRad' .* cosd(theta);
xRad_yPos = normXRad' .* sind(theta);

yRad_xPos = normYRad' .* cosd(theta);
yRad_yPos = normYRad' .* sind(theta);

figure(3);
plot(xRad_xPos, xRad_yPos);

figure(4);
plot(yRad_xPos, yRad_yPos);


