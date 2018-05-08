% height_below_horizon.m

% this is a script that calculates the height of objects hidden by the
% horizon, assuming no atmospheric refraction. Input the arclength distance
% between two locations and the observer height; ideally these are heights
% above sea level. The height of objects that can be seen is then given by
% h_object-h.
% The equations in here are derived from the spacecraft field of view
% equation, see enaflux2_port_rev2.m.

% radius of the earth in meters
%re=6.371e6;
% radius of the earth in miles
re=3959;

% h_obs is the height of the observer in meters.
%h_obs=1.5;
% height in miles:
h_obs=6/5280;

% stot is the total arclength between the two objects, in meters or miles
% as desired.
stot=1;

% the drop will be in miles or meters, depending on your units for re and
% h_obs.
h=-re+sqrt(re.^2+(2*re*h_obs+h_obs.^2)*(cos(stot/re)).^2+...
    re.^2*(sin(stot/re)).^2-re*sqrt((re+h_obs).^2-re.^2)*sin(2*stot/re))


