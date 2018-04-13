function [R_x, R_y] = vectorGeneration(imageAddress)
    image = imread(imageAddress);
    edge(