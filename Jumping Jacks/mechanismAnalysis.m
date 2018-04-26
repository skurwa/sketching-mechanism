% known parameters
R_A         = 
R_hand      = 
R_elbow     =    
R_B         =
R_O4        =    
R_O4elbow   =

theta2 = 30:1:90;
alpha = 
beta = 
gamma = 

fun = @(thetaElbow) vectorLoopX(thetaElbow,R_A, R_hand, R_elbow, R_B, R_O4, R_O4elbow, alpha, beta, gamma, theta2);

thetaElbow = fzero(fun, 0);
thetaHand = asind((-R_A*sind(theta2) - R_elbow*sind(thetaElbow) + R_B*sind(thetaElbow + alpha + beta) + R_O4*sind(thetaElbow + beta) + R_O4elbow*sind(thetaElbow - gamma))/R_hand);
theta4 = thetaElbow + beta;
theta6 = theta4 + alpha;
theta4_elbow = thetaElbow - gamma;




