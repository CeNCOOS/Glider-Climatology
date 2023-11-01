function y=runmean(x,n)
%y=runmean(x,n) calculates the n-point running mean of x.
%If x is a matrix the block mean of each column is calculated.
%The length of y will be length(x)-n+1.
%

[nrow,ncol]=size(x);
num=nrow-n+1;
y=zeros(num,ncol);
for i=1:num
   y(i,:)=mean(x(i:i+n-1,:));
end
