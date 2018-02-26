function [ Maxalt ] = MaxAlt( r,Wp,We,MW )
%Calculates the maximum altitude (m) a balloon can reach with radius r, payload
%weight Wp, empty weight We, and lifting gas with a molecular weight of MW.
i = 0;
Wtot = BalloonWeight(r,Wp,We,MW);
Wair = Weightdisplaced(r,0);
while Wair>Wtot
    i=i+1;
    h = 10*i;
    Wair = Weightdisplaced(r,h);
end
Maxalt = h-10;
end

