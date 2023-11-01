function wrapperavplots(line,basepath)
% function makeallplots(line,basepath)
% Makes all annual cycle plots.
% Arguments line {'90.0','80.0','66.7'} and basepath base directory.
% Writes all plots in an organized directory tree.
%
% D. Rudnick, August 2, 2016
% Load the file anncycTr.mat for this code.  Where it was saved earlier.
% The plots are of the averages and averages without the means.
% FLB Oct. 25, 2023

%Load annual cycle mat file
load(['anncyc' line(1:2)]); %#ok<LOAD> 

makemeanmapplots(meanmap,basepath);
%
makeavmapplots(avmap,avmaptm,basepath);
%
makeavmapnomeanplots(avmapnomean,avmapnomeantm,basepath);
%
makemeanmapsigplots(meanmapsig,basepath);
%
makeavmapsigplots(avmapsig,basepath);
%
makeavmapsignomeanplots(avmapsignomean,basepath);
% 
makeseasonsplots(avmap,basepath);