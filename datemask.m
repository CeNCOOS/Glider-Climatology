function mapmask=datemask(map)

% mask map using start and end dates of the timeseries 
%
%
% K.Zaba: Aug8,2016
% Note start date for the line is hard coded in this file.
% The Trinidad line started 2014/11/16.  Need to make sure that the times
% are compliant with what is needed or will get bad results.
%
% FLB Oct, 25, 2023

mapmask = map;

%% Start Date
lineID = map.line(1:2);
if strcmp(lineID,'66')
    startDate=datenum(2007,4,20); %#ok<DATNM> 
elseif strcmp(lineID,'80')
    startDate=datenum(2006,2,26); %#ok<DATNM> 
elseif strcmp(lineID,'90')
    startDate=datenum(2006,10,20); %#ok<DATNM> 
end
% Need code for Trinidad line
if strcmp(lineID,'Tr')
	startDate=datenum(2014,11,16); %#ok<DATNM> % NEED to ADD Month and Day!!
end

%% End Date
if isempty(map.config.update)
    endDate=ut2dn(map.config.timestamp);
else
    endDate=ut2dn(map.config.update(end));
end

%% Mask
mask = ut2dn(map.time)<startDate | endDate<ut2dn(map.time);

vars = fieldnames(map);
for k=1:length(vars)
    var0 = vars{k};
    if ~isstruct(map.(var0)) && ~isvector(map.(var0))
        d=size(map.(var0));
        if length(d)==2
            mapmask.(var0)(:,mask)=nan;
        elseif length(d)==3
            mapmask.(var0)(:,:,mask)=nan;
        end
    end
end