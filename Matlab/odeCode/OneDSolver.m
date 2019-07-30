function v = OneDSolver( a,b,xa,xb,F )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
v0=-10;
h=0.001;
vv=zeros(1,100);
vv(1)=v0;
t=a:h:b;
tolerance=1e-3;
%tolerance=1e2; %This code is to show the importance of tolerance
for i=1:99
    xv0=[xa vv(i)];
    xvh0=[xa vv(i)+1e-4];
    xvh=RK4(a,b,h,xvh0,F);
    xv=RK4(a,b,h,xv0,F);
    df=(xvh(end,1)-xv(end,1))./(1e-4);
    f=xv(end,1)-xb;
    vv(i+1)=vv(i)-f./df;
    difference=abs(vv(i+1)-vv(i));
    %The following codes are to show the rate ofconvergence
    %x = RK4( a,b,h,xv0,F );
    %plot(t,x(:,1),'b')
    %hold on
    if difference<tolerance
        break
    end
end
v=vv(i+1);