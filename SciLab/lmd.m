%%%%%%%局部均值分解（LMD）
%%%%%%%将信号分解成AM和FM部分
function [Am_d Fm_d]=lmd(x)
%%%%%Am_d幅值部分
%%%%%Fm_d调频部分
%%%%%x原始信号
%%%%%n分解信号的阶数，也可以不设置，默认就是分解到最后一层，此时暂时不设置
n=length(x);
temp_x=x;
%%%%%搜索局部最值
[inmin inmax inzero]=extr(x);
[tmin,tmax,zmin,zmax]=boundary_conditions(inmin,inmax,1:n,x,x,2);%%%%端点延拓

%%%%%做局部均值和包络
[localMaxMin indexTemp]=CombinMaxMin(tmin,tmax,zmin,zmax);
[local_mean local_en index]=LocalMeanEn(localMaxMin,indexTemp);

%%%%%本来应该用移动平均法做局部均值函数，这里还是利用cubic样条函数做的
interpl.method='cubic';%%%%不同的样条函数在这里换
LocalMeanFun=interp1(index,local_mean,1:n,interpl.method);
LocalEnFun=interp1(index,local_en,1:n,interpl.method);
Am_d=LocalEnFun;
hhhtt_tt=x-LocalMeanFun;
ssstt_tt=hhhtt_tt./LocalEnFun;

%%%%%判断ssstt_tt是不是纯调频信号
flag=1;
Delta_delta=1e-6;
temp_ss=find(ssstt_tt>1+Delta_delta | ssstt_tt<-1-Delta_delta);
[LineSize ColumnSize]=size(temp_ss);
flag=ColumnSize;
%%%CounterSize=1;
while flag %%%& CounterSize<100
    
    x=ssstt_tt;
    %%%%%搜索局部最值
   [inmin inmax inzero]=extr(x);
   [tmin,tmax,zmin,zmax]=boundary_conditions(inmin,inmax,1:n,x,x,2);%%%%端点延拓

   %%%%%做局部均值和包络
   [localMaxMin indexTemp]=CombinMaxMin(tmin,tmax,zmin,zmax);
   [local_mean local_en index]=LocalMeanEn(localMaxMin,indexTemp);

   %%%%%本来应该用移动平均法做局部均值函数，这里还是利用cubic样条函数做的
   LocalMeanFun=interp1(index,local_mean,1:n,interpl.method);
   LocalEnFun=interp1(index,local_en,1:n,interpl.method);
   Am_d=Am_d.*LocalEnFun;
   hhhtt_tt=x-LocalMeanFun;
   ssstt_tt=hhhtt_tt./LocalEnFun;
   temp_ss=find(ssstt_tt>1+Delta_delta | ssstt_tt<-1-Delta_delta);
   [LineSize ColumnSize]=size(temp_ss);
   flag=ColumnSize;
   %%%CounterSize=CounterSize+1;
end
Fm_d=ssstt_tt;

