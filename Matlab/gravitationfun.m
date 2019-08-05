function dx = gravitationfun( t,x,mass,G )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
N=length(mass);
dx=zeros(1,6*N);
dx(1:3*N)=x((3*N+1):6*N);
for j=1:N
    for i=1:N
        if i==j
            continue
        else
            r=x((3*i-2):(3*i))-x((3*j-2):(3*j));
            dx((3*j-2+3*N):(3*j+3*N))=dx((3*j-2+3*N):(3*j+3*N))+G.*mass(i).*r./(norm(r,2)^3);
        end
    end
end

