function [ x,y ] = flight( V,Theta,T,g )
%Plots the trajectory of a projectile acting with only the force of
%gravity. V = initial velocity m/s, Theta = launch angle (degrees), 
%T = plotting resolution, g = acceleration due to gravity m/s^2.
if V < 0
    return
end
if Theta < 0
    return
end
b = V*sind(Theta);%Quadratic coefficients
a = -.5*g;
c = 0;

t1 = (-b+sqrt(b^2-4*a*c))/(2*a);%Roots of parabolic trajectory
t2 = (-b-sqrt(b^2-4*a*c))/(2*a);

if t1>0
    t = t1;
end
if t2>0
    t = t2;
end
time = linspace(0,t,T);
x = V*cosd(Theta).*time;%X position versus time
y = -.5*g.*time.^2+V*sind(Theta).*time;%Y position versus time
end

