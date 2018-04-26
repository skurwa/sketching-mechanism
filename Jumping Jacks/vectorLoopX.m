function loop = vectorLoopX(thetaElbow,R_A, R_hand, R_elbow, R_B, R_O4, R_O4elbow, alpha, beta, gamma, theta2)
        
    thetaHand = asind((-R_A*sind(theta2) - R_elbow*sind(thetaElbow) + R_B*sind(thetaElbow + alpha + beta) + R_O4*sind(thetaElbow + beta) + R_O4elbow*sind(thetaElbow - gamma))/R_hand);
    
    loop = R_A*cosd(theta2) + R_hand*cosd(thetaHand) + R_elbow*cosd(thetaElbow) - R_B*cosd(thetaElbow + alpha + beta) - R_O4*cosd(thetaElbow + beta) - R_O4elbow*cosd(thetaElbow - gamma);
end
