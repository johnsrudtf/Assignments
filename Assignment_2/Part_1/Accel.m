function [ aSx,aSy,aMx,aMy ] = Accel( xM, yM, xS, yS, Ms, Mm, Me )
%Calculates the acceleration of the moon and spacecraft due to the
%gravitational forces of the three body problem. Earth is assumed fixed and
%centered in coordinate frame. Inputs are x and y locations of satellite
%and moon, as well as the moon, earth, and satellite masses. Output is x
%and y accelerations of the moon and satellite.
G = 6.674*10^(-11);%N(m/kg)^2 Gravitational constant

dms = sqrt((xM-xS)^2+(yM-yS)^2);
des = sqrt(xS^2+yS^2);
dem = sqrt(xM^2+yM^2);

Fmsx = G*Mm*Ms*(xM-xS)/dms^3;
Fesx = G*Me*Ms*(-xS)/des^3;
Fmsy = G*Mm*Ms*(yM-yS)/dms^3;
Fesy = G*Me*Ms*(-yS)/des^3;
Femx = G*Me*Mm*(-xM)/dem^3;
Fsmx = G*Ms*Mm*(xS-xM)/dms^3;
Femy = G*Me*Mm*(-yM)/dem^3;
Fsmy = G*Ms*Mm*(yS-yM)/dms^3;


aSx = (Fmsx+Fesx)/Ms;
aSy = (Fmsy+Fesy)/Ms;
aMx = (Femx+Fsmx)/Mm;
aMy = (Femy+Fsmy)/Mm;

end

