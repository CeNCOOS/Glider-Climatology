%
% code to create a file similar to calcofilines.mat
%
% This is code to generate basic info in a form that Dan's code wants for
% the Trinidad line.  Would need the slanted line for the Bodega line if we
% decicde to try that glider.  Trinidad is easy since it is at a constant
% latitude and only the longitude changes.
% FLB Oct. 25, 2023
lons=-125:-1:-130;
lats=[41.05,41.05,41.05,41.05,41.05, 41.05];
calcofilines.Trin.lat=lats;
calcofilines.Trin.lon=lons;