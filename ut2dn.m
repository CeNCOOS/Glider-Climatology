function dn=ut2dn(time)
% function dn=ut2dn(time) takes unixtime time and turns it into
% datenumber dn.
% 

dn=time/86400+datenum(1970,1,1); %#ok<DATNM> 
