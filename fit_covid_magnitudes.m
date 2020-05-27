
for indx = 1:6
   
X = motility_data(:,2); Y = motility_data(:,2+(indx)*2)/100;
X = [X Y]; X(any(isnan(X), 2), :) = []; 
Y=X(:,1); X = X(:,2);
[R,P] = corrcoef(X,Y);
[f,S]=polyfit(X,Y,1);


CI = polyparci(f,S,0.95);
XXX(indx,:)=[f(1) CI(1,1) CI(2,1)];
FS(indx,:)=f;
end

XXX



if 0
  
f = FS(1,:);
x = -0.5:0.01:0;
pan off;  hold on; 
plot(x,f(2) + x*f(1))


x0 = -0.026;
y0 = 0.033;

x1=0;
y1=f(2);
x2=1;
y2=f(1)+f(2);
d = abs((y2-y1)*x0 - (x2-x1)*y0+x2*y1-y2*x1)/sqrt((y2-y1)^2+(x2-x1)^2)

end

DDD = [];
TOTALIDX = horzcat(mobnindices,sindices);

for indx = 1:6   
X =  motility_data(:,2+(indx)*2)/100; Y = motility_data(:,2);
f=FS(indx,:);

for i=1:length(X)
x0 = X(i);
y0 = Y(i);

x1=0;
y1=f(2);
x2=1;
y2=f(1)+f(2);
d = abs((y2-y1)*x0 - (x2-x1)*y0+x2*y1-y2*x1)/sqrt((y2-y1)^2+(x2-x1)^2);

sg=sign(y0-(x0*f(1)+f(2)));
DDD(i,indx)=d*sg;
end

end

%[TOTALIDX' DDD]
figure;bar(TOTALIDX', DDD)




