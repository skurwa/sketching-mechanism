%David Ziemnicki
%Robotic Mechanism Design 
%A program to analyze the viability of a cam
%(dFollower,radii,torque,k,springLen)

function [plausible, accuracySumX, accuracySumY, missedX, missedY, problemsX, problemsY] = camPlausibility(dFollower,xRadii,yRadii,torque,k,springLen) 
    
    %dFollower is the diameter of the follower, torque is the supplied
    %motor torque, radii is the array of radii for the cam, and springLen
    %is the uncompressed length of the spring
    arraySize = length(xRadii);
    xRadii(arraySize+1:2*arraySize) = xRadii;
    yRadii(arraySize+1:2*arraySize) = yRadii;
    plausible = 1;
    
    accuracyX = ones(1,2*arraySize);
    missedX = zeros(1,arraySize);
    problemsX = zeros(1,arraySize);
    
    accuracyY = ones(1,2*arraySize);
    missedY = zeros(1,arraySize);
    problemsY = zeros(1,arraySize);
    
    for i = 1:arraySize
        relevPointX = ceil((arraySize*dFollower)/(2*pi*xRadii(i)));
        relevPointY = ceil((arraySize*dFollower)/(2*pi*yRadii(i)));
        %disp("For radii " + i + ", relevant radiis: " + relevDeg)
        
        if (relevPointX > 1) && (accuracyX(i))
            maxRad = max(xRadii(i+1:i+relevPointX));
            for j = i+1:i+relevPointX
                if (j <= arraySize) && (accuracyX(j))
                    if (xRadii(j) < maxRad) && (xRadii(j) < xRadii(i)) && (xRadii(j) < xRadii(i+relevPointX))
                        accuracyX(j) = 0;
                        missedX(j) = 1;
                    end
                end
            end
        end
        
        if (relevPointY > 1) && (accuracyY(i))
            maxRad = max(yRadii(i+1:i+relevPointY));
            for j = i+1:i+relevPointY
                if (j <= arraySize) && (accuracyY(j))
                    if (yRadii(j) < maxRad) && (yRadii(j) < yRadii(i)) && (yRadii(j) < yRadii(i+relevPointY))
                        accuracyY(j) = 0;
                        missedY(j) = 1;
                    end
                end
            end
        end
        
        if ((xRadii(i+1)-xRadii(i)) >= dFollower/2)
            plausible = 0;
            %disp("Cam X not possible because of radii: " + i)
            problemsX(i) = 1;
        end

        if ((yRadii(i+1)-yRadii(i)) >= dFollower/2)
            plausible = 0;
            %disp("Cam Y not possible because of radii: " + i)
            problemsY(i) = 1;
        end
        
        motorForceX = (torque/xRadii(i)) * cosd( (xRadii(i+1)-xRadii(i)) / ((2*pi*xRadii(i))/arraySize) );
        motorForceY = (torque/yRadii(i)) * cosd( (yRadii(i+1)-yRadii(i)) / ((2*pi*yRadii(i))/arraySize) );
        if ( k*(abs(springLen-xRadii(i))) + k*(abs(springLen-yRadii(i))) - motorForceX - motorForceY > 0)
            problemsX(i) = 1;
            problemsY(i) = 1;
            plausible = 0;
        end
    end
    
    accuracySumX = sum(accuracyX(1:arraySize))/arraySize;
    accuracySumY = sum(accuracyY(1:arraySize))/arraySize;
    
    if(plausible)
        disp("The cams are possible!")
        disp("The x follower will be " + 100*accuracySumX + "% accurate")
        disp("The y follower will be " + 100*accuracySumY + "% accurate")
        if ((accuracySumX < 1) || (accuracySumY < 1))
            for m = 1:arraySize       
                if (missedX(m))
                    %disp("The x follower will miss radii " + m)
                end
                if (missedY(m))
                    %disp("The y follower will miss radii " + m)
                end
            end
        end
    else
        disp("It's not possible!")
        for n = 1:arraySize
            if (problemsX(n))
                %disp("radii " + n + " on x Cam is a problem")
            end
            if (problemsY(n))
                %disp("radii " + n + " on y Cam is a problem")
            end
        end
    end
end
