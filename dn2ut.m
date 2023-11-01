function time=dn2ut(dn)
% function time=dn2ut(dn) takes datenumber dn and turns it into unixtime
% time.
%

time=(dn-datenum(1970,1,1))*86400; %#ok<DATNM> 
