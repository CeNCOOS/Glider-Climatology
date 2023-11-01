function y=runmeans(x,n)
%y=runmeans(x,n) calculates the n-point running mean of x.
%If x is a matrix the running mean of each column is calculated.
%The length of y will be fix(length(x)/n).
%

nrow=size(x,1);
A=spdiags(ones(nrow,n)/n,[0:n-1],nrow,nrow);
y=A*x;