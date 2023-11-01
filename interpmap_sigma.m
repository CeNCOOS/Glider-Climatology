function sigint=interpmap_sigma(mapstruct,sigsig)
%function to interpolate to surfaces from mapped data.
%
% Interpolation onto sigma surfaces no edit made beyond adding
% documentation.  FLB Oct. 25, 2023

sigma=mapstruct.sigma;
p=mapstruct.depth;

nsig=length(sigsig);
[nz,nx,ntime]=size(sigma);

sigint.line=mapstruct.line;
sigint.sigma=sigsig(:);
sigint.dist=mapstruct.dist;
sigint.lat=mapstruct.lat;
sigint.lon=mapstruct.lon;
if ntime > 1, sigint.time=mapstruct.time; end
sigint.depth=squeeze(nan(nsig,nx,ntime));

vars=fieldnames(mapstruct);
k=0;

if ntime > 1
   for kk=1:length(vars)
      if ~strcmp('sigma',vars{kk}) && ndims(mapstruct.(vars{kk})) == 3
         sigint.(vars{kk})=nan(nsig,nx,ntime);
         k=k+1;
         vsig{k}=vars{kk}; %#ok<AGROW> 
      end
   end
   for ix=1:nx
      for itime=1:ntime
         for jj=1:nsig
            j1=max(find(sigma(:,ix,itime) <= sigsig(jj))); %#ok<MXFND> 
            if ~isempty(j1) && j1 ~= nz
               coef=(sigsig(jj)-sigma(j1,ix,itime))/(sigma(j1+1,ix,itime)-sigma(j1,ix,itime));
               for k=1:length(vsig)
                  sigint.(vsig{k})(jj,ix,itime)=mapstruct.(vsig{k})(j1,ix,itime)+coef*(mapstruct.(vsig{k})(j1+1,ix,itime)-mapstruct.(vsig{k})(j1,ix,itime));
               end
               sigint.depth(jj,ix,itime)=p(j1)+coef*(p(j1+1)-p(j1));
            end
         end
      end
   end
else %this condition for meanmap
   for kk=1:length(vars)
      if ~strcmp('sigma',vars{kk}) && ~isvector(mapstruct.(vars{kk}))
         sigint.(vars{kk})=nan(nsig,nx);
         k=k+1;
         vsig{k}=vars{kk}; %#ok<AGROW> 
      end
   end
   for ix=1:nx
      for jj=1:nsig
         j1=max(find(sigma(:,ix) <= sigsig(jj))); %#ok<MXFND> 
         if ~isempty(j1) && j1 ~= nz
            coef=(sigsig(jj)-sigma(j1,ix))/(sigma(j1+1,ix)-sigma(j1,ix));
            for k=1:length(vsig)
               sigint.(vsig{k})(jj,ix)=mapstruct.(vsig{k})(j1,ix)+coef*(mapstruct.(vsig{k})(j1+1,ix)-mapstruct.(vsig{k})(j1,ix));
            end
            sigint.depth(jj,ix)=p(j1)+coef*(p(j1+1)-p(j1));
         end
      end
   end
end

end

