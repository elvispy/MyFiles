function [value,isterminal,direction] = SecaoTransversal(t,x,r,b)
%value=zeros(2,1);
%isterminal=zeros(2,1);
%direction=zeros(2,1);
value(1) = abs(x(3))-(r-1);
%value(2)=x(1).^2+x(2).^2-b.*(r-1);
isterminal(1)=0;
%isterminal(2)=0;
direction(1)=0;
%direction(2)=0;
end