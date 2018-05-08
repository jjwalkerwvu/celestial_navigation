% ephemeris_generator.m

% this script generates ephemeris data, with the goal of producing a lunar
% distance table.

rmoon=1737.0;
rearth=6371;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% procedure for spice kernels
addpath('/home/jjwalker/mice/lib/')
addpath('/home/jjwalker/mice/src/mice/')
%addpath('/usr/local/naif/mice/lib/')
%addpath('/usr/local/naif/mice/src/mice/')
cspice_tkvrsn('toolkit')
% this list of furnishings is inspired by the meta-kernel that I
% downloaded. This is all in the same order as shown in the meta-kernel,
% with the exception of the moon_sse frame definition.

cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/naif0011.tls')
cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/pck00010.tpc')
cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/moon_pa_de421_1900_2050.bpc')
%cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/de431_part-1.bsp')
%cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/de431_part-2.bsp')
%cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/de430.bsp')
cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/de432s.bsp')

% frame kernels
cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/moon_assoc_me.tf')
cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/moon_080317.tf')
cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/earth_fixed.tf')
% mars spk
cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/mar097s.bsp')
% jupiter spk
cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/jup310.bsp')
% saturn spk
%cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/040506AP_PE_94328_16357.bsp')
% furnish frame definition file for the moon in solar stationary
% coordinates.
cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/moon_sse.tf')
% this is the specific frame kernel needed to use the 'gse' reference frame
cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/rbsp_general011.tf')


% furnish the star map?
%cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/tycho2.bdb')
cspice_furnsh('/home/jeffw/Linux/Desktop/work/ldex/hipparcos.bin')
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% pick a start time for the generated table, perhaps today's date.
tstart_str='May 2 2018, 0:00 UTC';
tend_str='Apr 29 2019, 0:00 UTC';
et_start = cspice_str2et(tstart_str);
et_end = cspice_str2et(tend_str);
% make an array that goes from the start time in hour increments.
et_arr=et_start:3600:et_end;

% use this sample to return time strings
sample = 'Dec 25 2005, 18:15 UTC';
[ pic, ok, xerror ] = cspice_tpictr( sample );
% create the array of utc time strings.
ut_arr=cspice_timout(et_arr,pic);
% ut_hr picks out the hour from the ut_arr and turns it from a string to a
% number so it can be placed in the final array written to file later.
ut_hr=ut_arr(:,[14:15,17:18]);
% use mod to get rid of 2400 hr entries, make them 0000 instead?
ut_hr=roundn(str2num(ut_hr),2);
%ut_hr=uint16(ut_hr);

% now that the time array has been established, let's find out the lunar
% distance as observed from earth. We will need to do this for all
% celestial bodies of interest.

% use one-way correction, so that positions of planets and stars are given
% with respect to where an observer would see them.
abcor='lt';
% I assume iau_earth is centered at the earth's center.
% Is it possible to generate these in celestial, spherical coordinate system?
% I think there is a cspice function like rect to spherical or something?
% maybe use reclat_c? Can set all radii to 1 or something
[moon_state,~]=cspice_spkezr('moon',et_arr,'iau_earth',abcor,'Earth');
moon_pos=[moon_state(1,:); moon_state(2,:); moon_state(3,:)];
[sun_state,~]=cspice_spkezr('sun',et_arr,'iau_earth',abcor,'Earth');
sun_pos=[sun_state(1,:); sun_state(2,:); sun_state(3,:)];
[mars_state,~]=cspice_spkezr('mars',et_arr,'iau_earth',abcor,'Earth');
mars_pos=[mars_state(1,:); mars_state(2,:); mars_state(3,:)];
[jupiter_state,~]=cspice_spkezr('jupiter',et_arr,'iau_earth',abcor,'Earth');
jupiter_pos=[jupiter_state(1,:); jupiter_state(2,:); jupiter_state(3,:)];
[venus_state,~]=cspice_spkezr('venus',et_arr,'iau_earth',abcor,'Earth');
venus_pos=[venus_state(1,:); venus_state(2,:); venus_state(3,:)];
% [saturn_state,~]=cspice_spkezr('saturn',et_arr,'iau_earth',abcor,'Earth');

%   compute distances for every ephemeris object.
% I have only put the moon, sun, mars, jupiter, and venus here since they are
% the most readily visible. Might want to consider saturn, as this is also
% visible
moon_distance=sqrt(dot(...
    [moon_state(1,:); moon_state(2,:); moon_state(3,:)],...
    [moon_state(1,:); moon_state(2,:); moon_state(3,:)]));
sun_distance=sqrt(dot(...
    [sun_state(1,:); sun_state(2,:); sun_state(3,:)],...
    [sun_state(1,:); sun_state(2,:); sun_state(3,:)]));
mars_distance=sqrt(dot(...
    [mars_state(1,:); mars_state(2,:); mars_state(3,:)],...
    [mars_state(1,:); mars_state(2,:); mars_state(3,:)]));
jupiter_distance=sqrt(dot(...
    [jupiter_state(1,:); jupiter_state(2,:); jupiter_state(3,:)],...
    [jupiter_state(1,:); jupiter_state(2,:); jupiter_state(3,:)]));
venus_distance=sqrt(dot(...
    [venus_state(1,:); venus_state(2,:); venus_state(3,:)],...
    [venus_state(1,:); venus_state(2,:); venus_state(3,:)]));
% saturn_distance=sqrt(dot(...
%     [saturn_state(1,:); saturn_state(2,:); saturn_state(3,:)],...
%     [saturn_state(1,:); saturn_state(2,:); saturn_state(3,:)]));



% calculate distance angles (in units of degrees)
sun_moon=180/pi*acos(dot(moon_pos,sun_pos)./moon_distance./sun_distance);
mars_moon=180/pi*acos(dot(moon_pos,mars_pos)./moon_distance./mars_distance);
jupiter_moon=180/pi*acos(dot(moon_pos,jupiter_pos)./moon_distance./jupiter_distance);
venus_moon=180/pi*acos(dot(moon_pos,venus_pos)./moon_distance./venus_distance);
% saturn_moon=180/pi*acos(dot(moon_state,saturn_state)./moon_distance./saturn_distance);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% is it possible to use this to find information for stars???

ly_km_conv=9.461e+12;

% just use radius of size 1, doesn't matter
rad_vec=ones(size(ut_hr))';
mat=cspice_pxform('J2000','IAU_EARTH',et_arr);
radii=cspice_bodvrd( 'EARTH', 'RADII', 3 );
flat=(radii(1)-radii(3))/radii(1);

% regulus ephemeris
regulus_ra=(10+(8+22.311/60)/60)*15*ones(size(rad_vec));
% use ephemeris time to get the time series for right ascension
%regulus_lon=((regulus_ra-ut_hr/1e2)*15)';
regulus_dist=79.3*ones(size(rad_vec))*ly_km_conv;
regulus_dec=(11+(58+1.95/60)/60)*ones(size(rad_vec));
regulus_vec=cspice_radrec(regulus_dist,regulus_ra*cspice_rpd,regulus_dec*cspice_rpd);
for index=1:length(rad_vec)
    regulus_vec(:,index)=mat(:,:,index)*regulus_vec(:,index);
end
regulus_moon=180/pi*acos(dot(moon_pos,regulus_vec)./moon_distance./regulus_dist);

% antares ephemeris
antares_ra=(16+(29+24.45970/60)/60);
antares_lon=((antares_ra+ut_hr/1e2)*15)';
antares_dec=(-26-(25+55.2094/60)/60)*ones(size(rad_vec));
%antares_vec=cspice_radrec(rad_vec,antares_lon*cspice_rpd,regulus_dec*cspice_rpd);
%antares_vec=cspice_georec(antares_lon,antares_dec,rad_vec,radii(1),flat);

% pollux ephemeris
pollux_ra=(7+(45+18.94987/60)/60)*15*ones(size(rad_vec));
pollux_dec=(28+(1+34.3160/60)/60)*ones(size(rad_vec));
pollux_dist=33.78*ones(size(rad_vec))*ly_km_conv;
pollux_vec=cspice_radrec(pollux_dist,pollux_ra,pollux_dec);
for index=1:length(rad_vec)
    pollux_vec(:,index)=mat(:,:,index)*pollux_vec(:,index);
end
% compute lunar distance angles with the stars chosen.
% for index=1:length(et_arr);
%    antares_vec(:,index)=mat(:,:,index)*antares_vec(:,index); 
% end

%antares_moon=180/pi*acos(dot(moon_pos,antares_vec)./moon_distance);
pollux_moon=180/pi*acos(dot(moon_pos,pollux_vec)./pollux_dist./moon_distance);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% create one giant array?
header={'UTC','Sun','Mars','Jupiter','Venus'};
% 
%lunar_array=[ut_hr'; sun_moon; mars_moon; jupiter_moon; venus_moon; saturn_moon];
lunar_array=[ut_hr'; sun_moon; mars_moon; jupiter_moon; venus_moon];

% use dlmwrite('filename',matrix) when writing data to file.
txt=sprintf('%s\t',header{:});
txt(end)='';
dlmwrite('lunar_array.txt',txt,'');
dlmwrite('lunar_array.txt',lunar_array','precision','%.4f','-append','delimiter','\t');

% It's always good form to unload kernels after use, particularly in MATLAB
% due to data persistence.
%cspice_kclear;
