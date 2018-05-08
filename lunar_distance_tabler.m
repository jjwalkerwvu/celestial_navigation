% lunar_distance_tabler.m

% this is a script designed to create a table of angular distance between the
% moon and various celestial objects, and write to an ascii file, or some other 
% format

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Input the fixed stars here; 
% these are easiest because we just need right ascension and declination.
% Note, that these values change over time, slowly

% make each star a two element array; first element contains ra, and second 
% contains dec.
% I intend to convert all ra's to gha's.

pollux(1)=(7+45/60+18.94987/360)*15;
pollux(2)=(28+1/60+34.3160/3600)*pi/180;