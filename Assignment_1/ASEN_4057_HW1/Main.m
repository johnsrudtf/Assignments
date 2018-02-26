%Torfinn Johnsrud
%January 24 2018
%ASEN 4057 Aerospace Software Assignment 1
%%%----- Problem 1 -----%%%

V = 10;%Initial Velocity (m/s)
Theta = 45;%Launch Angle (Degrees)
T = 100;%Number of plotting points
g = 9.81;%m/s^2

[x,y] = flight(V,Theta,T,g);

figure
plot(x,y)
title('Flight Path');
xlabel('Horizontal Position (m)');
ylabel('Vertical Position (m)');

%%%----- Problem 2 -----%%%

x = [-3,12.1,20,0,8,3.7,-5.6,.5,5.8,10];
y = [-11.06,58.95,109.73,3.15,44.83,21.29,-27.29,5.11,34.01,43.25];
[m,b] = LeastSquares(x,y);
figure
plot(x,y,'o');
hold on;
x = linspace(min(x),max(x));
y = m*x+b;
plot(x,y);
xlabel('x');
ylabel('y');
title('Data and Best Fit Line');
legend('Data','Best Fit');
hold off;

%Test Case
x = [-5,-2,0,2,3,5,7,9,14];
y = [-.008,-.003,.001,.005,.007,.006,.009,.0145,.019];
[m,b] = LeastSquares(x,y);
figure
plot(x,y,'o');
hold on;
x = linspace(min(x),max(x));
y = m*x+b;
plot(x,y);
xlabel('Angle Of Attack [deg]');
ylabel('Coefficient of Lift');
title('Angle of attack versus Cl');
legend('Data','Best Fit');
hold off;


%%%----- Problem 3 -----%%%
%Part A is BalloonWeight
%Part B is Weightdisplaced
%Part C is MaxAlt
%Part D:
h = MaxAlt(3.5,5,.6,4.02)
