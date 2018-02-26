function f = OptBurn(deltaV,t,state,parameters,optParameter)
%OPTBURN  Finds the initial burn of the spacecraft that optimizes a given 
%  input: 'thrust' or 'time.'
%  
%  Inputs:		deltaV			- parameter guess
%  				t				- time [s]
%  				state			- state of system
%  				parameters		- parameters of system
%  				optParameters	- parameter to optimize
%  
%  Outputs:		f	- optimized parameters
%  
%  Example call:
%  		f = OptBurn(deltaV,t,state,parameters,'time')
%  
%  Created by:          Keith Covington
%  Created on:          01/27/2018
%  Last modified:       02/01/2018
%  
% *************************************************************************

% Get input deltaV
deltaV_x = deltaV(1);
deltaV_y = deltaV(2);

% Update state before integration
state(7) = state(7) + deltaV_x;
state(8) = state(8) + deltaV_y;

% Simulation options
%opts = odeset('Events',@stopping_point,'RelTol', 1e-8); % define events to stop ode45
opts = odeset('Events',@stopping_point); % define events to stop ode45
t=[1,1e27];

%Two different ways to call the ode
[t, allStates, te, ye, ie] = ode45(@(t,state) ODEroutine(t,state,parameters), t, state, opts);

% Evaluate
if ie == 2
	if strcmp(optParameter, 'thrust')
		f = norm([deltaV_x, deltaV_y]);
	elseif strcmp(optParameter, 'time')
		f = abs(te);
	else
		error(['Invalid optimization parameter: "' optParameter '"'])
	end
else
	f = 1e100;
end

