function vari=anncycinterp(A,variable,level,time,dist)
% 
% This function interpolates the data using the fits to the horizontal
% spacing.  Note need to make sure that the times are in the correct
% format.
%
% Updatd notes FLB Oct. 24, 2023
vari=nan(size(time));

timebin=2*pi*time/86400/365.25;
%keyboard;
if strcmp(variable,'t') || strcmp(variable,'s') || strcmp(variable,'fl') || strcmp(variable,'ox')||strcmp(variable,'cdom')||strcmp(variable,'bb')
   maxharmonic=size(A.(variable).sin,3);
   G=[ones(size(timebin)) sin(timebin*(1:maxharmonic)) cos(timebin*(1:maxharmonic))];
   
   ii=dist <= min(A.xcenter);
   mm=[A.(variable).constant(level,1); squeeze(A.(variable).sin(level,1,:)); squeeze(A.(variable).cos(level,1,:))];
   vari(ii)=G(ii,:)*mm;
   
   jj=dist >= max(A.xcenter);
   mm=[A.(variable).constant(level,end); squeeze(A.(variable).sin(level,end,:)); squeeze(A.(variable).cos(level,end,:))];
   vari(jj)=G(jj,:)*mm;
   
   dx=diff(A.xcenter);
   kk=find(~ii & ~jj & ~isnan(dist));
   for n=1:length(kk)
      xx=A.xcenter-dist(kk(n));
      np=find(xx(1:end-1).*xx(2:end) <= 0);
      
      mm=[A.(variable).constant(level,np:np+1); squeeze(A.(variable).sin(level,np:np+1,:))'; squeeze(A.(variable).cos(level,np:np+1,:))'];
      bracket=G(kk(n),:)*mm;
      vari(kk(n))=bracket*[xx(np+1); -xx(np)]/dx(np);
   end
   
elseif variable == 'u' || variable == 'v'
   maxharmonic=size(A.(variable).sin,2);
   G=[ones(size(timebin)) sin(timebin*(1:maxharmonic)) cos(timebin*(1:maxharmonic))];
   
   ii=dist <= min(A.xcenter);
   mm=[A.(variable).constant(1); A.(variable).sin(1,:)'; A.(variable).cos(1,:)'];
   vari(ii)=G(ii,:)*mm;
   
   jj=dist >= max(A.xcenter);
   mm=[A.(variable).constant(end); A.(variable).sin(end,:)'; A.(variable).cos(end,:)'];
   vari(jj)=G(jj,:)*mm;
   
   dx=diff(A.xcenter);
   kk=find(~ii & ~jj & ~isnan(dist));
   for n=1:length(kk)
      xx=A.xcenter-dist(kk(n));
      np=find(xx(1:end-1).*xx(2:end) <= 0);
      
      mm=[A.(variable).constant(np:np+1)'; A.(variable).sin(np:np+1,:)'; A.(variable).cos(np:np+1,:)'];
      bracket=G(kk(n),:)*mm;
      vari(kk(n))=bracket*[xx(np+1); -xx(np)]/dx(np);
   end
end
