%Trajectory of Payload Dorpped by Team Assailing Falcons
clc
clear all
format short g
tic 
g = 9.81;        %acceleration due to gravity
Cd_Howler = 0.1055;        %drag coefficient of Howler
Cd_Bottle = 0.147;         %drag coefficient of Bottle
rho = 1.225;     %density of air
A = 0.02;        %average cross section of the payload
m = 1;           %mass of the payload
H(1) = input('Enter the height of the plane in meters: ');
ty(1) = 0;       %duration of fall
Vy(1) = 0;       %velocity in downward direction
acc(1) = 9.81;   %acceleration in downward direction
Dy(1) = 0;       %upward drag force
dy(1) = 0;       %deceleration due to drag force
k = 2;
int = 0.001;     %time intervals for calculation in the loops
payload_type = input('Choose the Payload to be Dropped: Howlers, Bottle or Both: ', 's');

if payload_type == 'Both'
    howler_num = input('Enter the number of Howlers to be dropped: ');
    bottle_num = input('Enter the number of Water Bottles to be dropped: ');
    Vpa = input('Enter crusing velocity in m/s: '); 
    Vag = input('Enter the velocity of wind wrt to ground in m/s: ');
    angle = input('Enter the angle of Vag in degrees: ');
    [range_howler, R_howler, H_howler] = CalTrajectory('Howlers', Cd_Howler, A, m, H, ty, Vy, Dy, dy, acc, k, int, rho, g, Vpa, Vag, angle);
    [range_bottle, R_bottle, H_bottle] = CalTrajectory('Water Bottles', Cd_Bottle, A, m, H, ty, Vy, Dy, dy, acc, k, int, rho, g, Vpa, Vag, angle);
    range_final = ((range_bottle*bottle_num) + (range_howler*howler_num))/(bottle_num+howler_num);
    disp('-------------------------------');
    fprintf('Combined Range of payload= %2.7f feet \n', range_final);
    disp('-------------------------------');
    toc
    comet(R_howler*3.28,H_howler*3.28);
    hold on
    plot(R_howler*3.28,H_howler*3.28);
    xlabel('Horizontal displacement in feets ');
    ylabel('Vertical displacement in feets');
    title('COMBINED TRAJECTORY OF PAYLOAD');
elseif payload_type == 'Howlers'
    while H>0
        ty(k) = ty(k-1) + int;
        H(k) = H(k-1) - (Vy(k-1)*int + 0.5*acc(k-1)*int^2);
        Vy(k) = Vy(k-1) + acc(k-1)*int;
        Dy(k) = Cd_Howler*rho*((Vy(k))^2)*A/2;
        dy(k) = Dy(k)/m;
        acc(k) = g - dy(k); 
        k= k+1;
    end
    disp('-------------------------------');
    fprintf('Duration of free-fall= %10.7f sec \n', ty(k-1));
    disp('-------------------------------');
    L = length(ty);
    toc
    Vpa = input('Enter crusing velocity in m/s: '); 
    Vag = input('Enter the velocity of wind wrt to ground in m/s: ');
    angle = input('Enter the angle of Vag in degrees: ');
    tic
    Vpg = Vpa - Vag*cosd(angle);     %velocity of plane wrt ground
    Vx(1) = Vpg;     %velocity of payload in horizontal direction
    R(1) = 0;        %distance covered by payload in horizontal direction
    Dx(1) = Cd_Howler*1.225*(Vx(1)^2)*A/2;      %horizontal drag on the payload
    dx(1) = Dx/m;        %horizontal deceleration on the payload
    k = 2;
    Vx = [Vx(1), zeros(1,L-1)];
    R = [R(1), zeros(1,L-1)];
    Dx = [Dx(1), zeros(1,L-1)];
    dx = [dx(1), zeros(1,L-1)];
    for tx = 1:L-1
        R(k) = R(k-1) + (Vx(k-1).*int - 0.5.*dx(k-1)*int^2);
        Vx(k) = Vx(k-1) - dx(k-1).*int;
        Dx(k) = (Cd_Howler*1.225*0.5*A).*((Vx(k)).^2);
        dx(k) = Dx(k)./m;
        k = k+1;
    end
    disp('-------------------------------');
    fprintf('Range of payload= %2.7f feet \n', R(k-1)*3.28);
    disp('-------------------------------');
    toc
    comet(R*3.28,H*3.28);
    hold on
    plot(R*3.28,H*3.28);
    xlabel('Horizontal displacement in feets ');
    ylabel('Vertical displacement in feets');
    title('TRAJECTORY OF HOWLERS');    
elseif payload_type == 'Bottle'
    while H>0
        ty(k) = ty(k-1) + int;
        H(k) = H(k-1) - (Vy(k-1)*int + 0.5*acc(k-1)*int^2);
        Vy(k) = Vy(k-1) + acc(k-1)*int;
        Dy(k) = Cd_Bottle*rho*((Vy(k))^2)*A/2;
        dy(k) = Dy(k)/m;
        acc(k) = g - dy(k); 
        k= k+1;
    end
    disp('-------------------------------');
    fprintf('Duration of free-fall= %10.7f sec \n', ty(k-1));
    disp('-------------------------------');
    L = length(ty);
    toc
    Vpa = input('Enter crusing velocity in m/s: '); 
    Vag = input('Enter the velocity of wind wrt to ground in m/s: ');
    angle = input('Enter the angle of Vag in degrees: ');
    tic
    Vpg = Vpa - Vag*cosd(angle);     %velocity of plane wrt ground
    Vx(1) = Vpg;     %velocity of payload in horizontal direction
    R(1) = 0;        %distance covered by payload in horizontal direction
    Dx(1) = Cd_Bottle*1.225*(Vx(1)^2)*A/2;      %horizontal drag on the payload
    dx(1) = Dx/m;        %horizontal deceleration on the payload
    k = 2;
    Vx = [Vx(1), zeros(1,L-1)];
    R = [R(1), zeros(1,L-1)];
    Dx = [Dx(1), zeros(1,L-1)];
    dx = [dx(1), zeros(1,L-1)];
    for tx = 1:L-1
        R(k) = R(k-1) + (Vx(k-1).*int - 0.5.*dx(k-1)*int^2);
        Vx(k) = Vx(k-1) - dx(k-1).*int;
        Dx(k) = (Cd_Bottle*1.225*0.5*A).*((Vx(k)).^2);
        dx(k) = Dx(k)./m;
        k = k+1;
    end
    disp('-------------------------------');
    fprintf('Range of payload= %2.7f feet \n', R(k-1)*3.28);
    disp('-------------------------------');
    toc
    comet(R*3.28,H*3.28);
    hold on
    plot(R*3.28,H*3.28);
    xlabel('Horizontal displacement in feets ');
    ylabel('Vertical displacement in feets');
    title('TRAJECTORY OF BOTTLE');    
end

function [range, R, H] = CalTrajectory(Name, Cd, A, m, H, ty, Vy, Dy, dy, acc, k, int, rho, g, Vpa, Vag, angle)
    while H>0
        ty(k) = ty(k-1) + int;
        H(k) = H(k-1) - (Vy(k-1)*int + 0.5*acc(k-1)*int^2);
        Vy(k) = Vy(k-1) + acc(k-1)*int;
        Dy(k) = Cd*rho*((Vy(k))^2)*A/2;
        dy(k) = Dy(k)/m;
        acc(k) = g - dy(k); 
        k = k+1;
    end
    disp('-------------------------------');
    fprintf('Duration of free-fall for %s= %10.7f sec \n', Name, ty(k-1));
    disp('-------------------------------');
    L = length(ty);
    toc
    tic
    Vpg = Vpa - Vag*cosd(angle);     %velocity of plane wrt ground
    Vx(1) = Vpg;     %velocity of payload in horizontal direction
    R(1) = 0;        %distance covered by payload in horizontal direction
    Dx(1) = Cd*1.225*(Vx(1)^2)*A/2;      %horizontal drag on the payload
    dx(1) = Dx/m;        %horizontal deceleration on the payload
    k = 2;
    Vx = [Vx(1), zeros(1,L-1)];
    R = [R(1), zeros(1,L-1)];
    Dx = [Dx(1), zeros(1,L-1)];
    dx = [dx(1), zeros(1,L-1)];
    for tx = 1:L-1
        R(k) = R(k-1) + (Vx(k-1).*int - 0.5.*dx(k-1)*int^2);
        Vx(k) = Vx(k-1) - dx(k-1).*int;
        Dx(k) = (Cd*1.225*0.5*A).*((Vx(k)).^2);
        dx(k) = Dx(k)./m;
        k = k+1;
    end
    range = R(k-1)*3.28;
end
