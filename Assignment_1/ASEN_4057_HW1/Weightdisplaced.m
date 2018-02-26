function [ Wair ] = Weightdisplaced( r,h )
%Calculates weight of displaced air from balloon of radius r at altitude h.
if 0<h<=11000
    T = 15.04-.00649*h;
    P = 101.29*((T+273.15)/288.08)^5.256;
end
if 11000<h<=25000
    T = -56.46;
    P = 22.65*exp(1.73-.000157*h);
end
if h>25000
    T = 131.21+.00299*h;
    P = 2.488*((T+273.15)/216.6)^(-11.388);
end
rho = P/(.2869*(T+273.15));
Wair = 4*pi*rho*r^3/3;

end

