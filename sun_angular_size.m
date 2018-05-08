% sun_angular_size.m

% this is just a short script that plots apparent angular size of sun if it
% were much closer to the earth, circling as a "spotlight". 

% radius of the earth in meters
re=6.371e6;

theta_n=70*pi/180; % angle of sun above "horizon" at noon in radians
delta_n=(31+31/60)/60*pi/180;   % angular size of sun in radians

% observer latitude, in radians:
obs_lat=(41.6611)*pi/180;

% declination latitude formula, in radians: 
n=71;
% for the period 21 march to 22 september use
dec_lat=(23.5*pi/180)*sin(0.973*n); 
% where n is the number of days after 21 march

% for the period 23 september to 21 march, use
%dec_lat=(23.5*pi/180)*sin(n-5);
% where n is the number of days after 23 september

% s is the arclength or distance from observer location to the declination 
% latitude on some given date
s=re*(obs_lat-dec_lat);

% p is the arclength or distance from observer location to the north pole
% on some given date
p=re*(pi/2-obs_lat);

% r is the "radius of spotlight great circle", which is just s+p
r=s+p;

% create phi array; this is the azimuthal angle of the sun with respect to
% solar noon.

npoints=1e3;
% depending on the time of year, phi max will change. larger in summer,
% smaller in winter.
phi_max=120*pi/180;
phi_var=linspace(0,phi_max,npoints);

% the predicted angular size based on all the variables input so far:
delta_var=2*atan((s./(cos(theta_n)).*tan(delta_n/2))./(sqrt(s.^2*(tan(theta_n)).^2+...
    (sqrt(r.^2-p.^2*(sin(phi_var)).^2)-p*cos(phi_var)).^2)));

% Should I produce a theoretical prediction for the angular size of sun in
% "the globe" model? It will be almost constant...

% collate the experimental data
% phi_i=[];

% delta_i=[];

%~%~%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   plot the figure.

figure(1);
clf;
% convert phi and delta into degrees
plot(phi_var*180/pi,delta_var*180/pi);
% plot data points, actual data taken with sextant or other method.
%plot(phi_i,delta_i);
xlabel('Azimuthal Angle with Respect to Solar Noon');
ylabel('Angular size of Sun');

set(gcf, 'Color', [1,1,1]);