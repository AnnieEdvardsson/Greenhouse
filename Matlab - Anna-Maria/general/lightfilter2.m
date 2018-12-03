function fsig = lightfilter2(y,n)

%n=10;
A=1;
B=1/n*ones(1,n);

fsig=filter(B,A,y);