function [ dydt ] = ODEroutine( t,state,param, varargin)
%Called to outline the governing ODEs for the three body problem of
%Satellite, Moon, and Earth. dydt takes form of 
%[x_M, y_M, vx_M, vy_M, x_S, y_S, vx_S, vy_S]

%Physical properties

G	= param.G;
r_M = param.r_M;
r_E = param.r_E;
m_M = param.m_M;%Mass of Moon kg
m_E = param.m_E;%Mass of Earth kg
m_S = param.m_S;%Mass of Spacecraft kg

% If optimization attempts are passed in
if ~isempty(varargin)
	% Update state before integration
	state(7) = varargin{1};
	state(8) = varargin{2};
end

[aSx,aSy,aMx,aMy] = Accel(state(1),state(2),state(5),state(6),m_S,m_M,m_E);%dV/dt = a
dydt(1) = state(3);
dydt(2) = state(4);
dydt(3) = aMx;
dydt(4) = aMy;
dydt(5) = state(7);
dydt(6) = state(8);
dydt(7) = aSx;%dx/dt = V
dydt(8) = aSy;

dydt = dydt';
end

