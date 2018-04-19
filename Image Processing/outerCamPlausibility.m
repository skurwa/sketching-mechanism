%David Ziemnicki
%Robotic Mechanism Design 
%A program to analyze the viability of a cam
%(dFollower,radii,torque,k,springLen)

function [plausible, accuracySum, missed, problems] = outerCamPlausibility(dFollower,radii,name) 
    
    %dFollower is the diameter of the follower, torque is the supplied
    %motor torque, radii is the array of radii for the cam, and springLen
    %is the uncompressed length of the spring
    arraySize = length(radii);
    radii(arraySize+1:2*arraySize) = radii;
    plausible = 1;
    accuracy = ones(1,2*arraySize);
    missed = zeros(1,arraySize);
    problems = zeros(1,arraySize);
    
    for i = 1:arraySize
        relevPoint = ceil((arraySize*dFollower)/(2*pi*radii(i)));
        %disp("For degree " + i + ", relevant degrees: " + relevDeg)
        
        if (relevPoint > 1) && (accuracy(i))
            maxRad = max(radii(i+1:i+relevPoint));
            
            for j = i+1:i+relevPoint
                if (j <= arraySize) && (accuracy(j))
                    if (radii(j) < maxRad) && (radii(j) < radii(i)) && (radii(j) < radii(i+relevPoint))
                        %disp("Missed degree: " + j)
                        accuracy(j) = 0;
                        missed(j) = 1;
                    end
                end
            end
        end
        
        if ((radii(i+1)-radii(i)) >= dFollower/2)
            plausible = 0;
            disp("Not possible because of degree: " + i)
            problems(i) = 1;
        end
        
%         if ( k*(springLen-radii(i)) + (torque/radii(i)) * cosd( (radii(i+1)-radii(i)) / ((2*pi*radii(i))/360) ) > 0)
%             plausible = 0;
%         end
    end
    
    accuracySum = sum(accuracy(1:arraySize))/arraySize;
    
    if(plausible)
        disp(name + " cam is possible!")
        disp("The follower will be " + 100*accuracySum + "% accurate")
        if (accuracySum < 1)
            for m = 1:arraySize       
                if (missed(m))
                    disp("The follower will miss degree " + m)
                end
            end
        end
    else
        disp("It's not possible!")
        for n = 1:arraySize
            if (problems(n))
                disp("Degree " + n + " is a problem")
            end
        end
    end
end
