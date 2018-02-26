function [dXdt] = placeholderFunction(t, inputs, parameters)
%NACA_AIRFOIL  takes in the specs of a NACA 4-digit airfoil and produces 
%  (x,y) coordinates depending on the number of panels desired...also 
%  produces a plot of the airfoil.
%  
%  
%  Inputs:		m	- max camber
%  				p	- location of max camber
%  				t	- thickness
%  				c	- chord length
%  				N	- number of panels to use
%
%  Outputs:		x	- vector of x-locations of boundary points
%  				y	- vector of y-locations of boundary points
%  
%  Example calls:	
%  		[x, y] = NACA_Airfoil(m, p, t, c, N)
%  		[x, y] = NACA_Airfoil(m, p, t, c, N, 'PlotsOff')
% 
%  
%  Created by:     Keith Covington
%  Created on:     10/12/2017
%  Last modified:  10/21/2017
% *************************************************************************


