function Xnew = Picard( t,Xold,F )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x0=ones(length(t),1)*[0 1];
Xnew=x0+interecr(t,F(t,Xold));
end

