function [ctd,adp] = combineMissions(line,doADP) %#ok<INUSD> 
doADP=0;
% Concatenate data from all missions along a particular CalCOFI line. The 
% function is hard-coded to include the variables 't','s','u','v' in the
% output structure 'ctd.' Input parameters are:
    % line: '66.7','80.0', or '90.0'
    % doADP: true to include depth-dependent velocities ('udop','vdop') in
    %        the output structure 'adp'
% This script includes ALL mission data, whereas combinesecs.m organized 
% the data into 'sections'. 
%
% K.Zaba, May22,2014
% D. Rudnick, September 8, 2016 - update to use cugn.txt
% This code is not used as we have amodified version for Trinidad glider
% data.

% Paths
adppth='.';
% original links below
%list = 'cugn.txt';    % file with list of archive deployments

% CTD Variables
ctd1D = {'time','lon','lat','dist','offset', ...
         'timeu','lonu','latu','distu','offsetu','u','v'};
%ctd2D = {'t','s'};
% My change for glider variables on Trinidad glider 
ctd2D = {'t','s'};
%ctd2D = {'t','s','ox','fl','cdom','bb'};
nctd1D = length(ctd1D); 
nctd2D = length(ctd2D); 
depthLevels = (0:10:500)'; 
nz = length(depthLevels);

% Initialize CTD Output 
ctd.line=line;
ctd.depth = depthLevels;
for iictd1D = 1:nctd1D
    ctd.(ctd1D{iictd1D}) = [];
end
for iictd2D = 1:nctd2D
    ctd.(ctd2D{iictd2D}) = [];
end

% ADP Variables
if doADP
    
    adp1D = {'time','lon','lat','dist','offset'};
    adp2D = {'u','v','abs'};
    
    nadp1D = length(adp1D);
    nadp2D = length(adp2D);
    
    % Initialize ADP Output
    adp.line=line;
    adp.depth = depthLevels;
    for iiadp1D = 1:nadp1D
        adp.(adp1D{iiadp1D}) = [];
    end
    for iiadp2D = 1:nadp2D
        adp.(adp2D{iiadp2D}) = [];
    end
    
else
    
    adp = {};
    
end
    
% ReadIn Mission Data
fid=fopen(list);
deps = textscan(fid,'%s %s','Delimiter',',');
fclose(fid);
linestr = ['line' line(1:2)];
ii=find(strncmp(line,deps{2},2));
ctd.missions=deps{1}(ii);

for idep=1:length(ii)
    filename=[adppth,'/',deps{1}{ii(idep)} '.mat'];
%    load(filename,'bindata'); %original
    load(filename,'bindata');
    [bindata.dist,bindata.offset]    = calcdistfromshoreCRM(bindata.lon, ...
                                          bindata.lat,linestr);
    [bindata.distu,bindata.offsetu] = calcdistfromshoreCRM(bindata.lonu, ...
                                          bindata.latu,linestr);                  
    nz0 = length(bindata.depth);
    for iictd1D=1:nctd1D
        ctd.(ctd1D{iictd1D}) = [ctd.(ctd1D{iictd1D}); bindata.(ctd1D{iictd1D})];
    end
    for iictd2D=1:nctd2D
        if nz0>nz
            bindata.(ctd2D{iictd2D}) = bindata.(ctd2D{iictd2D})(1:nz,:);
        end
        ctd.(ctd2D{iictd2D}) = [ctd.(ctd2D{iictd2D}) bindata.(ctd2D{iictd2D})];
    end
    
    if doADP
        if exist(fullfile(adppth,filename),'file')   % then there is adp data
            load(fullfile(adppth,filename),'binadp')
            binadp.time   = bindata.time;
            binadp.lon    = bindata.lon;
            binadp.lat    = bindata.lat;
            binadp.dist   = bindata.dist;
            binadp.offset = bindata.offset;
            nz0 = length(binadp.depth);
            for iiadp1D=1:nadp1D
                adp.(adp1D{iiadp1D}) = [adp.(adp1D{iiadp1D}); bindata.(adp1D{iiadp1D})];
            end
            for iiadp2D=1:nadp2D
                if nz0>nz
                    binadp.(adp2D{iiadp2D}) = binadp.(adp2D{iiadp2D})(1:nz,:);
                end
                adp.(adp2D{iiadp2D}) = [adp.(adp2D{iiadp2D}) binadp.(adp2D{iiadp2D})];
            end
            if (length(adp.time)~=length(adp.u))
                nmissingadpprofiles = length(adp.time)-length(adp.u);
                for iiadp2D=1:nadp2D
                    adp.(adp2D{iiadp2D}) = [adp.(adp2D{iiadp2D}) nan(nz,nmissingadpprofiles)];
                end
            end
        else
            npt = length(bindata.(ctd1D{1}));
            for iiadp1D = 1:nadp1D
                adp.(adp1D{iiadp1D}) = [adp.(adp1D{iiadp1D}); nan(npt,1)];
            end
            for iiadp2D = 1:nadp2D
                adp.(adp2D{iiadp2D}) = [adp.(adp2D{iiadp2D}) nan(nz,npt)];
            end
        end
    end
    clear bindata binadp
end
