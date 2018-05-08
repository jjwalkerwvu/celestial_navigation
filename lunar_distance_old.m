% lunar_distance.m

% this script returns ephemeris data for the sun, various planets, and 
% stars, and (hopefully) a table of lunar distance angles between the moon
% these objects.

D_prime=(20+(32+31/2)/60)*pi/180;

% use D_gmt if you want to work backwards to find out what you should
% measure for D_prime.
T_gmt=(3+35/60);
D_gmt=(20.7858)*pi/180;

H_prime=(26.54)*pi/180;

h_prime=(26+31.5/60)*pi/180;

% geometrical constants
re=3959;
dme=.25e6;
dms=93e6;

P=asin(re/dme*cos(H_prime));
p=asin(re/dms*cos(h_prime));

H=H_prime+P;
h=h_prime+p;

r_fact=4*93e6;



answer1=.5*r_fact*(1-(cos(h)/cos(h_prime))^2)+...
    .5/r_fact*((1-cos(H)/cos(H_prime))^2)+cos(H)*cos(h)/...
    cos(H_prime)/cos(h_prime)*cos(D_prime);

answer2=cos(H)*cos(h)/cos(H_prime)/cos(h_prime)*(...
    cos(D_prime)-cos(H_prime-h_prime))+cos(H-h);

% compute D from known ephemeris data?

dec_m=pi/180*[18.41 18.43 18.456];

dec_mars=pi/180*[20.993 20.993 20.993];

gha_m=pi/180*[48.65 63.143 77.638];

gha_mars=pi/180*[85.0417 98.088 113.135];

D=180/pi*acos(sin(dec_m).*sin(dec_mars)+cos(dec_m).*cos(dec_mars).*...
    cos(gha_m-gha_mars));


% Dunthorne's equation to clear the lunar distance:
D_clear=180/pi*acos(cos(H)*cos(h)/cos(H_prime)/cos(h_prime)*...
    (cos(D_prime)-cos(H_prime-h_prime))+cos(H-h))

% linear interpolation to find gmt:
T1=3;
T2=4;
D1=20.626;
D2=20.9;


TD=T1+(T2-T1)*(D_clear-D1)/(D2-D1)

% inversrion of dunthrone's equation, to tell you what you should measure
180/pi*acos(cos(H_prime)*cos(h_prime)/cos(H)/cos(h)*...
    (cos(D_gmt)-cos(H-h))+cos(H_prime-h_prime))