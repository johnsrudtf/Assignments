% *************************************************************************
% 
%  This script operates as the Main script for ASEN 4057 Assignment #2.
%  In this assignment, we model the Apollo 13 manuevers used to slingshot 
%  around the Moon and return to Earth.
%       
%  Authors:	Keith Covington
% 			Torfinn Johnsrud
% 
%  Created:		01/24/2018
%  Modified:	02/09/2018
%
% *************************************************************************

clear all; close all; clc;	% housekeeping
set(0, 'defaulttextInterpreter', 'latex')	% plotting necessities



%% Physical properties

G	= 6.674e-11;		% gravitational constant [N*m^2/kg^2]
m_M	= 7.34767309e22;	% mass of moon [kg]
m_E	= 5.97219e24;		% mass of Earth [kg]
m_S	= 28833;			% mass of spacecraft [kg]
r_M	= 1737100;			% radius of moon [m]
r_E = 6371000;			% radius of Earth [m]

% Package into a struct to pass into integration function
parameters = struct('G',	G, ...
					'm_M',	m_M, ...
					'm_E',	m_E, ...
					'm_S',	m_S, ...
					'r_M',	r_M, ...
					'r_E',	r_E);


%% Initial conditions

t_0			= 0;	% initial time [s]

% Initial conditions of Earth
x_E_0		= 0;	% initial x-position of Earth
y_E_0		= 0;	% initial y-position of Earth
vx_E_0		= 0;	% initial x-comp. of velocity of Earth
vy_E_0		= 0;	% initial y-comp. of velocity of Earth

% Initial conditions of Moon
theta_M_0	= 42.5;			% initial angular position of the Moon [degrees]
d_EM_0		= 384403000;	% initial distance between Earth and Moon [m]
v_M_0		= sqrt( (G*m_E^2) / ( (m_E+m_M) * d_EM_0) ); % initial speed of spacecraft [m/s]
x_M_0		= d_EM_0 * cosd(theta_M_0);	% initial x-position of Moon
y_M_0		= d_EM_0 * sind(theta_M_0);	% initial y-position of Moon
vx_M_0		= -v_M_0 * sind(theta_M_0);	% initial x-comp. of velocity of Moon
vy_M_0		= v_M_0 * cosd(theta_M_0);	% initial y-comp. of velocity of Moon

% Initial conditions of spacecraft
theta_S_0	= 50;			% initial angular position of the S/C [degrees]
d_ES_0		= 338000000;	% initial distance between Earth and S/C [m]
v_S_0		= 1000;			% initial speed of spacecraft [m/s]
x_S_0		= d_ES_0 * cosd(theta_S_0);	% initial x-position of S/C
y_S_0		= d_ES_0 * sind(theta_S_0);	% initial y-position of S/C
vx_S_0		= v_S_0 * cosd(theta_S_0);	% initial x-comp. of velocity of S/C
vy_S_0		= v_S_0 * sind(theta_S_0);	% initial y-comp. of velocity of S/C

% Package initial conditions into a vector
state = [	
		% Initial conditions of Moon		
          x_M_0		
          y_M_0		
          vx_M_0		
          vy_M_0		
				 
		% Initial conditions of spacecraft		
          x_S_0		
          y_S_0		
          vx_S_0		
          vy_S_0		
		 ]';



%% Optimize initial velocity vector

% Optimization parameters
t=[1,1e15];								% time for integration ode45
options = optimset('Display','iter');	% optimization options


% Narrow down initial conditions for optimization using coarse grid
gridSize	= 20;
gridBounds	= 100;
x = GridOpt(t,state,parameters,'thrust', gridSize, gridBounds);

% Update initial state to include optimized initial burn
state(7) = state(7) + x(1);
state(8) = state(8) + x(2);

% Display results
fprintf('Optimizing for minimum thrust:\n')
fprintf('Delta V vector (vx,vy): [%f, %f] m/s.\n', x(1), x(2))




%% Calculate flight path using ode45

opts = odeset('Events',@stopping_point); % define events to stop ode45
t=[1,1e27];

%Two different ways to call the ode
[t, allStates] = ode45(@(t,state) ODEroutine(t,state,parameters), t, state, opts);

% Extract states
x_M  = allStates(:,1);
y_M  = allStates(:,2);
vx_M = allStates(:,3);
vy_M = allStates(:,4);
x_S  = allStates(:,5);
y_S  = allStates(:,6);
vx_S = allStates(:,7);
vy_S = allStates(:,8);



%% Plot results of simulation

figure
hold on
grid on
grid minor
title('Flight Paths', 'FontSize', 16)
plot(x_S,y_S,'b');
plot(x_M,y_M,'r');
h1 = plot(x_S,y_S,'b');
plot(x_S(1),y_S(1),'bo');
h3 = plot(x_M,y_M,'r');
plot(x_M(1),y_M(1),'ro');
earthFig = earth_sphere('m');
view([0 90])
legend([h1,h3],{'Spacecraft''s Path','Moon''s Path'});
%axis([1.5*-d_EM_0 1.5*d_EM_0 1.5*-d_EM_0 1.5*d_EM_0]);

%% Use Custom Integration Function
state(8) = state(8)+1;
state(7) = state(7)+.5;
[Y, Time, term, accel] = RK4method([0,1e6],state,parameters);
figure
hold on
grid on
grid minor
title('Flight Paths Custom Integration', 'FontSize',16);
plot(Y(5,:),Y(6,:),'b');
plot(Y(1,:),Y(2,:),'r');
earthFig = earth_sphere('m');
view([0 90])
legend('Spacecraft''s Path', 'Moon''s Path');


