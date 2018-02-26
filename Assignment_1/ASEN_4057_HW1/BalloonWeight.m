function [ Wtot ] = BalloonWeight( r,P,b,MW )
%Finds the total weight of a balloon counting payload and internal gas
% r = baloon radius; P = payload weight; b = balloon weight; MW = molecular
% weight of gas inside balloon
rho0 = 1.225;%kg/m^3

Wgas = 4*pi*rho0*r^3/3*(MW/28.966);%Weight ofgas inside balloon

Wtot = Wgas+P+b;
end

