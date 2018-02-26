function [ Y,Time,term,accel ] = RK4method( t,state,param )
%Author: Torfinn Johnsrud
%Date Modified: Feb 7 2018
%state = [xM, yM, vxM, vyM, xS, yS, vxS, vyS]
%Inputs: t = [t_0,t_end]; state = initial conditions; paramerters = radii
%and masses for two body problem.
%Outputs: Solution Y for all variables within state; Time = vector of time
%steps used; term = termination condition 1 for moon crash, 2 for earth
%crash, 3 for lost to space, 0 for time limit reached; accel = vector of 
%satellite acceleration magnitudes at each timestep.
G	= param.G;
r_M = param.r_M;
r_E = param.r_E;
m_M = param.m_M;%Mass of Moon kg
m_E = param.m_E;%Mass of Earth kg
m_S = param.m_S;%Mass of Spacecraft kg

y = state.';
Y = zeros(length(y),t(2));
Time = zeros(t(2),1);
i = t(1);
z = 1;
term = 0;

accel = zeros(t(2),1);

while i<t(2)  % calculation loop
    Y(:,z) = y;
    inter = Y(:,z);
    [aSx,aSy,aMx,aMy] = Accel(Y(1,z),Y(2,z),Y(5,z),Y(6,z),m_S,m_M,m_E);
    
    accel(z)=norm([aSx,aSy]);
    
    if norm([aSx,aSy])>.1 %Change time step based on acceleration
        h = 100;
    else h = 250;
    end
    Time(z+1) = Time(z)+h;
    k1y1 = h*Y(3,z);%
    k1y2 = h*Y(4,z);
    k1y3 = h*aMx;
    k1y4 = h*aMy;
    k1y5 = h*Y(7,z);
    k1y6 = h*Y(8,z);
    k1y7 = h*aSx;
    k1y8 = h*aSy;
    
    inter = inter + .5*[k1y1;k1y2;k1y3;k1y4;k1y5;k1y6;k1y7;k1y8];%[xM1,yM1,vxM1,vyM1,xS1,yS1,vxS1,vyS1]
    [aSx1,aSy1,aMx1,aMy1] = Accel(inter(1),inter(2),inter(5),inter(6),m_S,m_M,m_E);
    
    k2y1 = h*inter(3);
    k2y2 = h*inter(4);
    k2y3 = h*aMx1;
    k2y4 = h*aMy1;
    k2y5 = h*inter(7);
    k2y6 = h*inter(8);
    k2y7 = h*aSx1;
    k2y8 = h*aSy1;
    inter = [Y(1,z);Y(2,z);Y(3,z);Y(4,z);Y(5,z);Y(6,z);Y(7,z);Y(8,z)]+.5*[k2y1;k2y2;k2y3;k2y4;k2y5;k2y6;k2y7;k2y8];
    [aSx2,aSy2,aMx2,aMy2] = Accel(inter(1),inter(2),inter(5),inter(6),m_S,m_M,m_E);
    
    k3y1 = h*inter(3);
    k3y2 = h*inter(4);
    k3y3 = h*aMx2;
    k3y4 = h*aMy2;
    k3y5 = h*inter(7);
    k3y6 = h*inter(8);
    k3y7 = h*aSx2;
    k3y8 = h*aSy2;
    inter = [Y(1,z);Y(2,z);Y(3,z);Y(4,z);Y(5,z);Y(6,z);Y(7,z);Y(8,z)]+[k3y1;k3y2;k3y3;k3y4;k3y5;k3y6;k3y7;k3y8];
    [aSx3,aSy3,aMx3,aMy3] = Accel(inter(1),inter(2),inter(5),inter(6),m_S,m_M,m_E);
    
    k4y1 = h*inter(3);
    k4y2 = h*inter(4);
    k4y3 = h*aMx2;
    k4y4 = h*aMy2;
    k4y5 = h*inter(7);
    k4y6 = h*inter(8);
    k4y7 = h*aSx2;
    k4y8 = h*aSy2;
    
    k_1 = [k1y1;k1y2;k1y3;k1y4;k1y5;k1y6;k1y7;k1y8];
    k_2 = [k2y1;k2y2;k2y3;k2y4;k2y5;k2y6;k2y7;k2y8];
    k_3 = [k3y1;k3y2;k3y3;k3y4;k3y5;k3y6;k3y7;k3y8];
    k_4 = [k4y1;k4y2;k4y3;k4y4;k4y5;k4y6;k4y7;k4y8];
    

    y = y + 1/6*(k_1+2*k_2+2*k_3+k_4);
    z = z+1;
    i = i+h;
    %Crashes into Moon
    if norm([y(1)-y(5),y(2)-y(6)])<r_M
        term = 1;
        break
    end
    %Crashes into Earth
    if norm([y(5),y(6)])<=r_E
        term = 2;
        break
    end
    %Reaches two moon radiuses from Earth
    if norm([y(5),y(6)])>2*norm([state(1),state(2)])
        term = 3;
        break
    end
end
Y(:,z) = y;
Y = Y(:,1:z);
Time = Time(1:z);
accel = accel(1:z);
end

