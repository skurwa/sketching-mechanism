%David Ziemnicki
%Robotic Mechanism Design 
%A program to analyze the viability of a cam
%(dFollower,radii,torque,k,springLen)

function [plausible, accuracySum, missed, problems] = innerCamPlausibility(dFollower,radii) 
    
    %dFollower is the diameter of the follower, torque is the supplied
    %motor torque, radii is the array of radii for the cam, and springLen
    %is the uncompressed length of the spring
    radii(361:721) = radii;
    plausible = 1;
    accuracy = ones(1,720);
    missed = zeros(1,360);
    problems = zeros(1,360);
    
    for i = 1:360
        relevDeg = ceil((360*dFollower)/(2*pi*radii(i)));
        %disp("For degree " + i + ", relevant degrees: " + relevDeg)
        
        if (relevDeg > 1) && (accuracy(i))
            minRad = min(radii(i+1:i+relevDeg));
            
            for j = i+1:i+relevDeg
                if (j <= 360) && (accuracy(j))
                    if (radii(j) > minRad) && (radii(j) > radii(i)) && (radii(j) > radii(i+relevDeg))
                        %disp("Missed degree: " + j)
                        accuracy(j) = 0;
                        missed(j) = 1;
                    end
                end
            end
        end
        
        if ((radii(i)-radii(i+1)) >= dFollower/2)
            plausible = 0;
            disp("Not possible because of degree: " + i)
            problems(i) = 1;
        end
        
%         if ( k*(springLen-radii(i)) + (torque/radii(i)) * cosd( (radii(i+1)-radii(i)) / ((2*pi*radii(i))/360) ) > 0)
%             plausible = 0;
%         end
    end
    
    accuracySum = sum(accuracy(1:360))/360;
    
    if(plausible)
        disp("It's possible!")
        disp("The follower will be " + 100*accuracySum + "% accurate")
        if (accuracySum < 1)
            for m = 1:360        
                if (missed(m))
                    disp("The follower will miss degree " + m)
                end
            end
        end
    else
        disp("It's not possible!")
        for n = 1:360
            if (problems(n))
                disp("Degree " + n + " is a problem")
            end
        end
    end
end
