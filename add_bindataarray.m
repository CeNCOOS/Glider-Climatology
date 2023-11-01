% Code to load Trinidad head glider data files and add the bindata array to
% the matlab file.  The data are bin to every 10m in the vertical.
% The list below are the old deployments
% Need to modify for the current deployment and make so it is automated.
% Code created for currently archived Trinidad head glider data as recieved
% from OSU before transmission to IOOS glider dac.
%
% Created by FLB 2023/11/1
%
%load ./UW130_20150309T2005/seaglider130_20150309.mat
load ./UW130_20160523T1828/seaglider130.mat
%load ./UW130_20170605T1834/seaglider130_20170605.mat
%load ./UW130_20181107T1832/seaglider130.mat
%load ./UW130_20200612T1914/seaglider130_2020.mat
%load ./UW157_20141116T2118/seaglider_157_deploy1.mat
%load ./UW157_20150917T1833/seaglider157.mat
%load ./UW157_20161021T1807/seaglider157.mat
%load  ./UW157_20180417T1832/seaglider157.mat;
%load ./UW157_20190916T0000/seaglider157.mat
%load ./UW157_20200917T0000/seaglider157.mat
%load ./UW646_20190409T0000/seaglider646_20190409.mat
%load ./UW646_20210816T0000/seaglider646.mat
%load ./UW646_20211112T0000/seaglider646.mat
%load ./UW646_20220907T0000/seaglider646.mat
%load ./UW685_20230816T0000/seaglider685.mat;
%load seaglider685.mat;
%
% Nominal inshore end for the Trinidad glider line\
%
latshore=41.05;
lonshore=124+09/60+29/60/60;
lonshore=-lonshore;
%
% compute along line distance from inshore end. 
% gdist is currently a local function on FLBs desktop and needs to be made
% avialable more generally for access.
%
dist=gdist(tlatarr,tlonarr,latshore,lonshore);
% set zeros in data arrays to NaN
% zeros mess up the computatoins but NaN is checked for and ignored.
%-------
% QC section with deployment specific code
%-------
ll=tarr==0;
tarr(ll)=NaN;
ll=sarr==0;
sarr(ll)=NaN;
% QC for specific deployments to remove bad data.    Specific profiles were
% manually inspected and determined to be bad where a specific index is
% given.  Additionally too low a salinity were also removed except if it
% appeared to be a real event.  Most salinities were over 30 PSU.
% this is for 157 20200917
%sarr(180,:)=NaN;
% this is for 157 20161021
%ll=sarr <= 30;
%sarr([170,329,360,444,486,685,693,735],1)=NaN;
%sarr(ll)=NaN;
% this is for 157 20150917
%subs=sarr([577:590],:);
%ll=sarr <= 32;
%sarr(ll)=NaN;
%sarr(577:590,:)=subs;
%
% this is for 130 20160523
sarr(464,:)=NaN;
sarr(304,:)=NaN;
ll=oxyarr <=0;
oxyarr(ll)=NaN;
ll=oxyarr > 500;
oxyarr(ll)=NaN;
% this is for 646 20190409
%oxyarr(183,:)=NaN;
ll=flarr < 0;
flarr(ll)=NaN;
ll=bbarr < 0;
bbarr(ll)=NaN;
ll=cdomarr < 0;
cdomarr(ll)=NaN;
%--------
% end of QC specific code
% -------
% shape is profile number, depth
bins=0:10:500;
%bins=10:10:500; % This is Dan Rudnick's depth array
[np,nd]=size(ptarr);
lb=length(bins);
% create empty arrays for processing
newp=nan(np,lb-1);
newtemp=nan(np,lb-1);
newtime=nan(np,lb-1);
newdist=nan(np,lb-1);
newlat=nan(np,lb-1);
% salinity
newsalt=nan(np,lb-1);
% oxygen
newox=nan(np,lb-1);
% fluorescence
newfl=nan(np,lb-1);
% cdom
newcdom=nan(np,lb-1);
% bb
newbb=nan(np,lb-1);
% loop through and average the data to create the new arrays at the
% specified depth bins.
for j=1:np
    disp(j)
    for k=1:lb
        if k==lb
            maxp=510;
        else
            maxp=bins(k+1);
        end            
        ind=find((ptarr(j,:)>= bins(k))&(ptarr(j,:) < maxp));
        newp(j,k)=nanmean(ptarr(j,ind)); %#ok<NANMEAN> 
        newtemp(j,k)=nanmean(tarr(j,ind)); %#ok<NANMEAN> 
        newtime(j,k)=nanmean(ttarr(j,ind)); %#ok<NANMEAN> 
        newdist(j,k)=nanmean(dist(j,ind)); %#ok<NANMEAN> 
        newlat(j,k)=nanmean(tlatarr(j,ind)); %#ok<NANMEAN>
        % salinity
        inds=find((psarr(j,:)>= bins(k))&(psarr(j,:) < maxp));
        newsalt(j,k)=nanmean(sarr(j,inds)); %#ok<NANMEAN>
        % oxygen
        indo=find((poarr(j,:)>= bins(k))&(poarr(j,:) < maxp));
        newox(j,k)=nanmean(oxyarr(j,indo)); %#ok<NANMEAN>
        % fluorescence
        indf=find((pfarr(j,:)>= bins(k))&(pfarr(j,:) < maxp));
        newfl(j,k)=nanmean(flarr(j,indf)); %#ok<NANMEAN>
        % cdom
        indc=find((pcarr(j,:)>= bins(k))&(pcarr(j,:) < maxp));
        newcdom(j,k)=nanmean(cdomarr(j,indc)); %#ok<NANMEAN>
        % bb
        indb=find((pbbarr(j,:)>= bins(k))&(pbbarr(j,:) < maxp));
        newbb(j,k)=nanmean(bbarr(j,indb)); %#ok<NANMEAN>
    end
end
% Fill in the bindata structure with the depth averaged values
bindata.depth=bins;
bindata.t=newtemp;
bindata.s=newsalt;
bindata.fl=newfl;
bindata.ox=newox;
bindata.cdom=newcdom;
bindata.bb=newbb;
% these need to be 1-D
bindata.time=ttarr(:,1);
bindata.lat=tlatarr(:,1);
bindata.lon=tlonarr(:,1);
%
% This data is not contained in all of the deployment files currently on
% the system.  Reprocessing of early deployments are necessary to get the
% integrated u and v components that were not save initially.
%
% bindata.timeuv=timeuv;
% bindata.latu=tlatarr(:,1);
% bindata.lonu=tlonarr(:,1);
% bindata.u=uarr;
% bindata.v=varr;
[lt,ld]=size(newsalt);
% create a pressure array from the averaged depths so that theta and sigma
% may be computed.
newp=repmat(bins,lt,1);
theta=sw_ptmp(newsalt,newtemp,newp,0);
sigma=sw_pden(newsalt,newtemp,newp,0);
bindata.sigma=sigma;
bindata.theta=theta;
rho=sw_dens(newsalt,newtemp,newp);
bindata.rho=rho;
%
% deployment specific output files with a name to indicate that the bindata
% arrays is contained in the file.
%
%save OSU130_20150309_bindata2.mat;
save OSU130_20160523_bindata2.mat
%save OSU130_20170605_bindata2.mat
%save OSU130_20181107_bindata2.mat
%save OSU130_20200612_bindata2.mat
%save OSU157_20141116_bindata2.mat
%save OSU157_20150917_bindata2.mat
%save OSU157_20161021_bindata2.mat
%save OSU157_20180417_bindata2.mat
%save OSU157_20190916_bindata2.mat
%save OSU157_20200917_bindata2.mat
%save OSU646_20190409_bindata2.mat
%save OSU646_20210816_bindata2.mat
%save OSU646_20211112_bindata2.mat
%save OSU646_20220907_bindata2.mat
%save OSU685_20230816_bindata2.mat

