function meanmap=anncyc2meanmap(A)
% function meanmap=anncyc2meanmap
% Takes annual cycle structure A and makes structure meanmap with t, s, u,
% v.
%
% D. Rudnick, July 28, 2016
%
% Create the meanmap structure.  Modified to have ancillary variables
% beyond those above.
% Note this is called by allanncyc.m  It uses the output of the data fit
% (the constant values from the fits are the means).  This is the mean over
% the time period of the fit.
% 
% Updated notes FLB Oct. 24 2023.

meanmap.line=A.line;
meanmap.depth=A.depth;
meanmap.dist=A.xcenter;
meanmap.lat=A.lat;
meanmap.lon=A.lon;
meanmap.t=A.t.constant;
meanmap.s=A.s.constant;
meanmap.fl=A.fl.constant;
meanmap.ox=A.ox.constant;
meanmap.cdom=A.cdom.constant;
meanmap.bb=A.bb.constant;
meanmap.u=A.u.constant;
meanmap.v=A.v.constant;
