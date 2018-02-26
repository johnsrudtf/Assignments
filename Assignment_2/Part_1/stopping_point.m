function [value,isterminal,direction] = stopping_point(t, state)
%  STOPPING_POINT  Stops the numerical integration if one of the 
%  termination conditions have been satisfied:
%  	1. The spacecraft has crashed into the moon.
%  	2. The spacecraft has returned to Earth.
%  	3. The spacecraft is lost to the vast reaches of outer space.
%  
%  
%  Inputs:	t		- time [s]
%  			state	- state of system
%  
%  Outputs:	value		- value
%  			isterminal	- isterminal
%  			direction	- direction
%  
%  Created by:		Keith Covington
%  Created on:		01/27/2018
%  Last modified:	01/27/2018
%  
% *************************************************************************


%% Condition #1: The spacecraft has crashed into the moon.

% Define proximity to moon's surface
r_M = 1737100;	% radius of Moon [m]
x_M = state(1);	% x-position of Moon [m]
y_M = state(2);	% y-position of Moon [m]
x_S = state(5);	% x-position of spacecraft [m]
y_S = state(6);	% y-position of spacecraft [m]

% Distance from center of Moon to center of the spacecraft
distance = sqrt( (x_S-x_M)^2 + (y_S-y_M)^2 );

% Distance from spacecraft to surface of the Moon
value(1) = distance - r_M;
isterminal(1) = 1;
direction(1) = -1;



%% Condition #2: The spacecraft has returned to Earth.

% Define proximity to Earth's surface
r_E = 6371000;	% radius of Earth [m]
x_E = 0;		% x-position of Earth [m]
y_E = 0;		% y-position of Earth [m]
x_S = state(5);	% x-position of spacecraft [m]
y_S = state(6);	% y-position of spacecraft [m]

% Distance from center of Earth to center of the spacecraft
distance = sqrt( (x_S-x_E)^2 + (y_S-y_E)^2 );

% Distance from spacecraft to surface of the Earth
value(2) = distance - r_E;
isterminal(2) = 1;
direction(2) = -1;


%% Condition #3: The spacecraft is lost to the vast reaches of outer space.
% (Spacecraft's distance form Earth is twice the distance between the Earth
% and Moon).

% Define proximity to Earth's surface
d_EM = 384403000;	% distance from Earth to Moon [m]
x_E = 0;			% x-position of Earth [m]
y_E = 0;			% y-position of Earth [m]
x_S = state(5);		% x-position of spacecraft [m]
y_S = state(6);		% y-position of spacecraft [m]

% Distance from center of Earth to center of the spacecraft
distance = sqrt( (x_S-x_E)^2 + (y_S-y_E)^2 );

% Distance from spacecraft to surface of the Earth
value(3) = 2*d_EM;
isterminal(3) = 1;
direction(3) = -1;



end
