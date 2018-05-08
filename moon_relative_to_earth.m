function [x_moon,y_moon,z_moon,phi_moon] = moon_relative_to_earth(et)
%moon_relative_to_earth.m
%   You need the "improved_arctan.m" function for this function to work.
%   Also, you need to load spice kernels first before calling this
%   function.
%   
%   et  -   The ephemeris time for the satellite of interest, in this case
%   it's the moon.
%   
%   x,y,z,phi are in gse coordinates.


% initialize the needed arrays and constants
%r_earth=6371;
%outside_indices=[];
phi_moon=zeros(size(et));
x_moon=zeros(size(et));
y_moon=zeros(size(et));
z_moon=zeros(size(et));
data_size=length(et);
for index=1:data_size
    % progress bar
    if ~mod(index-2,data_size/20)
		disp([num2str((index-2)/data_size*100,'%.2f') '%'])
    end
    

    [pos, lt] = cspice_spkpos('moon', et(index), 'gse','NONE','earth');
    x_moon(index)=pos(1);
    y_moon(index)=pos(2);
    z_moon(index)=pos(3);
    phi_moon(index)=improved_arctan(x_moon(index),y_moon(index))*180/pi;
    
%     % if the moon is between 270 and 90 degrees, it is definitely outside
%     % the earth's magnetosphere
%     if phi_moon(index)>270 || phi_moon(index)<90
%         outside_indices=[outside_indices index];
%     % if it is outside 270 and 90 degrees, it might still be outside the
%     % magnetosphere
%     elseif abs(y_moon)-r_earth>abs(x_moon)
%         outside_indices=[outside_indices index];
%         
%    
%     end
    
end

%size(outside_indices)

end


