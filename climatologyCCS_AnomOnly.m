function [config,anommap]=climatologyCCS_AnomOnly(lineID,vari)

% Wrapper script for computing a full climatology of glider-measured
% anomalies on a specified CalCOFI line. The script compute 2D objective
% maps (in across-shore distance and time) at 10-m depth intervals. The
% resulting grids are 3D: <ndepth,ndist,ntime>. Input parameters are:
    % lineID: '66.7', '80.0', or '90.0'
    % vari:   't','s','u','v'
    %         for multiple variables, 'vari' needs to be a cell array, 
    %         e.g. {'t','s','u','v'}
% This script consists of two loops: the outer loop iterates through all
% input variables and the inner loop iterates through all depth levels. The
% output structures are:
    % 'config':     record of parameters used in the mapping computation
    % 'anommap':    objective maps of anomalies from the annual cycle
% In addition, the 'anommap' structure includes error maps for each 
% variable and the depth/spatial/temporal grids. 
% 
%
% K.Zaba May13,2016 
%
% This is the second big function to run for the glider anomaly output.
% This has been modified for the Trinidad line data files.  It takes a fair
% amount of time to run (approx 3 hrs currently, with the 10m vertical
% spacing).  It outputs a file that is necessary for the next big step in
% the anomaly computation.  It has been modified to use the glider's
% ancillary variables.  This code calls anncycinterp,
% generateHovMap_AnomOnly, generateGrid, calcposalonglineCRM,
% computeCovMtrx, combineMissions_var
% FLB Oct. 24, 2023

t_start = tic;

% Parametrs
Lx = 30;                        % length scale, in km
Lt = 60;                        % time scale, in days
gauss = [1 -1/Lx^2 -1/Lt^2];    % [amp, -1/Lx^2, -1/Lt^2]
%dx = 5; % original                         % spatial resolution of map (km)
dx=10;
dt = 10;                        % temporal resolution of map (days)
isdoy = true;                   % produde map at same dates for each year
noise = 0.1;                    % noise to signal ratio

mindistthresh = -5;             % minimum along-line distance threshold, km
if strcmp(lineID(1:2),'90')
    maxoffthresh = 90;          % minimum across-line offset threshold, 90 km for line 90
else
    maxoffthresh = inf;         % minimum across-line offset threshold, infinity for lines 66 and 80
end 

% Variables
if ~iscell(vari)
    vari = {vari};
end
nvari = length(vari);
variStr1D = {'u','v'};          % 1D variables
%variStr2D = {'t','s','fl'};     % 2D variables
variStr2D = {'t','s','ox','fl','cdom','bb'};     % 2D variables
ii1DVar=ismember(vari,variStr1D);  n1D=length(find(ii1DVar));   % 1D variables
ii2DVar=ismember(vari,variStr2D);  n2D=length(find(ii2DVar));   % 2D variables
vari = [vari(ii1DVar) vari(ii2DVar)];                           
varitype = [repmat({'1D'},[1,n1D]) repmat({'2D'},[1,n2D])];

% Load Data
ctd = combineMissions_var(lineID,variStr2D);
%keyboard;
% Generate spatial and temporal grids
distVals = ctd.dist;                % along-line distance
timeVals = ctd.time;                % unix-time
timeVals=dn2ut(timeVals); % new code to convert to unix time from matlab datenum
depthVals = ctd.depth;              % depth levels to loop through (for 2D Variables)
ndepth = length(depthVals);         % number of depth levels
[grddist,grdtime] = generateGrid(distVals,timeVals,dx,dt,isdoy);
%keyboard;
% For line 66.7, limit the maximum extent of the spatial grid to 400m
if (strcmp(lineID,'66.7'))
    grddist = grddist(grddist<=400);
end
nx = length(grddist);
nt = length(grdtime);
[grdlon,grdlat,linespecs.xsta,linespecs.ysta] = calcposalonglineCRM(grddist,lineID);

% Configuration Parameters
timestamp = java.lang.System.currentTimeMillis/1000;    % timestamp for map computation, in UTC
config = struct('line',lineID,'linespecs',linespecs,'Lx',Lx,'Lt',Lt, ...
                'dx',dx,'dt',dt,'noise',noise,'timestamp',timestamp, ...
                'update',[]);

% Load Annual Cycle Coefficients
avcoef = load(['anncyc', lineID(1:2) '.mat'],'A');
avcoef = avcoef.A;
%keyboard;
% Initialize output structure 'anommap'
anommap.line = lineID;                           % line ID
anommap.dist = grddist;                          % spatial grid
anommap.time = grdtime;                          % temporal grid
anommap.depth = depthVals;                       % depth levels
anommap.lon = grdlon;   anommap.lat = grdlat;    % lon/lat position
for ivar = 1:nvari
    if ismember(vari{ivar},variStr1D)
        grdvari = NaN*zeros(nt,nx);              % 1D data
    elseif ismember(vari{ivar},variStr2D)
        grdvari = NaN*zeros(nt,nx,ndepth);       % 2D data
    end
    anommap.(vari{ivar})     = grdvari;          % anomaly
    anommap.err.(vari{ivar}) = grdvari;          % error
end
anommap = orderfields(anommap,['line','depth','dist','time','lon','lat',vari,'err']);
%
%keyboard;
% Output file name
fname = ['map_',lineID(1:2),'_AnomOnly.mat'];
%keyboard;
delete(fname);  % if filename already exists in directory, delete it.


%% Loop through variables
for ivar=1:nvari
    
    vari0 = vari{ivar};
    disp(['Computing maps for vari: ',vari0])
    
    % Covariance matrices (A,B) only computed once for each
    % variable type (1D and 2D). 
    if (ivar==1 || ~strcmp(varitype{ivar-1},varitype{ivar}))
        
        clear A B
        
        if strcmp(varitype{ivar},'1D')      % 1D variable
            dist = ctd.distu;
            time = ctd.timeu;
            offset = ctd.offsetu; 
            ndepth = 1;
        elseif strcmp(varitype{ivar},'2D')  % 2D variable
            dist = ctd.dist;
            time = ctd.time;
            time=dn2ut(time); % new code since time we have is in dn not ut
            offset = ctd.offset;
            ndepth = length(anommap.depth); 
        end
        
        % Implement along-line distance threshold and across-line offset
        % threshold for the projection. If the distance is less than the
        % minimum distance threshold ('mindistthresh') and/or if the offset
        % is greater than the maximum offset threshold ('maxoffthresh'),
        % then do not include the corresponding data point. 
        iiproj = (dist>=mindistthresh & abs(offset)<=maxoffthresh); 
        dist = dist(iiproj);
        time = time(iiproj); 
    
        % 2D grid for map
        [xx,tt] = meshgrid(anommap.dist,anommap.time); 
        
        % Covariance Matrices
        [A,B] = computeCovMtrx(dist,time,xx,tt,gauss,noise);
        
    end
    
    % Data
    if strcmp(varitype{ivar},'1D')
        data = ctd.(vari0)';
    elseif strcmp(varitype{ivar},'2D')
        data = ctd.(vari0);
    end
   % keyboard;
    data = data(:,iiproj);
    
    % Determine whether the error map computation is necessary for the
    % variable of this iteration, 'vari0'. For the following variable 
    % pairs: {'u','v'} and {'udop','vdop'}, the error map only needs to
    % be computed once because it is the same for both components of 
    % the velocity vector pair. 
    computeErrMap = true;
    switch vari0
        case 'u' 
            vari00 = 'v';
        case 'v'
            vari00 = 'u';
        otherwise
            vari00 = [];
    end
    variPrevious = vari(1:ivar-1);
    if any(strcmp(vari0,{'u','v'}))
        if any(strcmp(vari00,variPrevious))
            computeErrMap = false;
        end
    end
    
    %% Loop through depth levels
    for idepth = 1:ndepth
        
        % Data
        data0 = data(idepth,:)';
        
        % Remove nans
        igood = (~isnan(dist) & ~isnan(time) & ~isnan(data0));
        dist0 = dist(igood);
        time0 = time(igood);
        data0 = data0(igood); 
        
        % Remove annual cycle
        avdata0 = anncycinterp(avcoef,vari0,idepth,time0,dist0);
        data0 = data0-avdata0;
        
        % Generate 'anommap'
        hovmap = generateHovMap_AnomOnly(A(igood,igood),B(:,igood),data0, ...
                                            xx,tt,gauss,computeErrMap);
        anommap.(vari0)(:,:,idepth) = hovmap.data;
        if computeErrMap
            anommap.err.(vari0)(:,:,idepth) = hovmap.mse;
        else
            anommap.err.(vari0)(:,:,idepth) = anommap.err.(vari00)(:,:,idepth);
        end
         
        % Save with each iteration
        save(fname,'config','anommap')
        
        % Display
        if (ndepth>1)
            disp(['    ',num2str(anommap.depth(idepth)),' m']);
        end
        
        % Track computation time
        t_end = toc(t_start);
        if (ndepth>1)
            computedDepths = [anommap.depth(1) anommap.depth(idepth)];
        else
            computedDepths = [];
        end
        save('t_makeClimatology','t_end','computedDepths')
        
    end
    
end

% After maps are computed for all variables, switch the dimension order to
% <ndist,ntime> for 1D variables and <ndepth,ndist,ntime> for 2D variables.
for ivar=1:nvari
    
    vari0 = vari{ivar};
    
    if strcmp(varitype{ivar},'1D')
        dimOrder = [2 1];
    elseif strcmp(varitype{ivar},'2D')
        dimOrder = [3 2 1];
    end
    
    anommap.(vari0)     = permute(anommap.(vari0),dimOrder);
    anommap.err.(vari0) = permute(anommap.err.(vari0),dimOrder); 
    
    % Save permuted structures with each iteration
    save(fname,'config','anommap')
    
end