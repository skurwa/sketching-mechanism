clear,clc,clf
A = zeros(2,361);
for i=2:120
    A(1,i) = A(1,i-1)+(1/119);
end

for i=121:360
    A(1,i) = A(1,i-1)-(1/240);
end

for i=121:240
    A(2,i) = A(2,i-1)+(1/120);
end

for i=241:360
    A(2,i) = A(2,i-1)-(1/120);
end

plot(0,0)
hold on
A(1,:)=A(1,:)+1;
A(2,:)=A(2,:)+1;
% plot(A(1,:),A(2,:),'k')
% hold on
dFollower1 = .5;

[plausible, accuracySum, missed, problems] = innerCamPlausibility(dFollower1, A(1,:));


for j = 1:360
    if(missed(j))
        plot(A(1,j),A(2,j),'+')
        hold on
    else
        plot(A(1,j),A(2,j),'o')
hold on
    end
end

figure();

xArray_X = [];
xArray_Y = [];
follX = [];
follY = [];

for k = 1:360
    xArray_X(k) = A(1,k)*cosd(k-1);
    xArray_Y(k) = A(1,k)*sind(k-1);
    follX(k) = dFollower1*cosd(k-1);
    follY(k) = dFollower1*sind(k-1);
end


plot(0,0, '+')
hold on
plot(xArray_X,xArray_Y);
plot(follX,follY);
axis([-5 5 -5 5])
