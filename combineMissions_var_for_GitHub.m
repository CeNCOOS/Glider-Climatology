function ctd = combineMissions_var(line,vars)

% % Concatenate data from all missions along a particular CalCOFI line. Use variables 
% in cell array vars. Input parameters are:
% line: '66.7','80.0', or '90.0'
    % vars: cell array of variables
%
% K.Zaba, May22,2014
% D. Rudnick, September 8, 2016 - update to use cugn.txt
% D. Rudnick, March 12, 2018 - update to use vars and data in binmat
%
% Code modified for the Trinidad line (depth levels adjusted to 10m from
% 5m).  Additionally paths that are in ths code are adjusted for running
% under test and will need to be modified for use in other locations.
% FLB Oct. 24, 2023.

% Paths
list = 'trinidad_glider.txt';    % file with list of archive deployments

% CTD Variables
%ctd1D = {'time','lon','lat','dist','offset', ...
%         'timeu','lonu','latu','distu','offsetu','u','v'};
ctd1D = {'time','lon','lat','dist','offset'};
ctd2D = vars;
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

    
% ReadIn Mission Data
fid=fopen(list);
deps = textscan(fid,'%s %s','Delimiter',',');
fclose(fid);
linestr = ['line' line(1:2)];
ii=find(strncmp(line,deps{2},2));
ctd.missions=deps{1}(ii);

for idep=1:length(ii)
   %filename=[deps{1}{ii(idep)} '_bin.mat'];
   filename=[deps{1}{ii(idep)} '.mat'];
   if exist(filename,'file')
      load(filename,'bindata');
   else
      load(deps{1}{ii(idep)},'bindata');
   end
      
      [bindata.dist,bindata.offset]    = calcdistfromshoreCRM(bindata.lon, ...
         bindata.lat,linestr);
%      [bindata.distu,bindata.offsetu] = calcdistfromshoreCRM(bindata.lonu, ...
%         bindata.latu,linestr);
      for iictd1D=1:nctd1D
         ctd.(ctd1D{iictd1D}) = [ctd.(ctd1D{iictd1D}); bindata.(ctd1D{iictd1D})];
      end
      for iictd2D=1:nctd2D
         %keyboard;
         if isfield(bindata,ctd2D{iictd2D})
            ctd.(ctd2D{iictd2D})=[ctd.(ctd2D{iictd2D}) bindata.(ctd2D{iictd2D})(:,1:nz)']; % first if depth so transpose
            %ctd.(ctd2D{iictd2D})=[ctd.(ctd2D{iictd2D}) bindata.(ctd2D{iictd2D})(1:nz,:)];
         else
            %ctd.(ctd2D{iictd2D})=[ctd.(ctd2D{iictd2D}) nan(size(bindata.t(1:nz,:)))];
            ctd.(ctd2D{iictd2D})=[ctd.(ctd2D{iictd2D}) nan(size(bindata.t(:,1:nz)'))]; % first is depth so transpose
         end
      end
      
      clear('bindata');
end
%end
