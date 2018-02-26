function optParam = GridOpt(t,state,parameters,optParameter, gridSize, gridBounds)
%GRIDOPT  Finds the initial burn of the spacecraft that optimizes a given 
%  input: 'thrust' or 'time.'
%  
%  Inputs:		t				- time [s]
%  				state			- state of system
%  				parameters		- parameters of system
%  				optParameters	- parameter to optimize
%  				gridSize		- size of grid to use
%  				gridBounds		- initial bounds of parameters in grid
%  
%  Outputs:		optParam	- optimized parameters
%  
%  Example call:
%  		optParam = GridOpt(deltaV,t,state,parameters,optParameter)
%  
%  Created by:          Keith Covington
%  Created on:          02/09/2018
%  Last modified:       02/09/2018
%  
% *************************************************************************

%% Create grid

% Define initial parameter vectors for grid
paramVec_x = linspace(-gridBounds,gridBounds, gridSize);
paramVec_y = linspace(-gridBounds,gridBounds, gridSize);
[paramGrid_x, paramGrid_y] = ndgrid(paramVec_x, paramVec_x);

% Run ode45 integration on each coordinate of grid
opts = odeset('Events',@stopping_point); % define events to stop ode45
t=[1,1e27];
f = arrayfun(											...
			@(param1,param2) OptBurn([param1 param2],	...
			t, state, parameters, 'thrust'),			...
			paramGrid_x,paramGrid_y						...
			);

% Get initial guess that resulted in minimum thrust
[minBurn, ind] = min(f(:));
minX = paramGrid_x(ind)
minY = paramGrid_y(ind)



%% Make a new, smaller grid and find minimum ("zoom in")

gridWidth = gridBounds/gridSize*3;
gridSize = 200;

% Define initial parameter vectors for grid
paramVec_x = linspace( ...
		max([-gridWidth+minX, -100]), min([gridWidth+minX, 100]), ...
		gridSize);
paramVec_y = linspace( ...
		max([-gridWidth+minY, -100]), min([gridWidth+minY, 100]), ...
		gridSize);

[paramGrid_x, paramGrid_y] = ndgrid(paramVec_x, paramVec_y);


% Run ode45 integration on each coordinate of grid
opts = odeset('Events',@stopping_point); % define events to stop ode45
t=[1,1e27];
f2 = arrayfun(												...
				@(param1,param2) OptBurn([param1 param2],	...
				t, state, parameters, 'thrust'),			...
				paramGrid_x,paramGrid_y						...
			);

[minBurn, ind] = min(f2(:));
minX = paramGrid_x(ind);
minY = paramGrid_y(ind);


optParam = [minX minY];




end
