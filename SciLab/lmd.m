%%%%%%%�ֲ���ֵ�ֽ⣨LMD��
%%%%%%%���źŷֽ��AM��FM����
function [Am_d Fm_d]=lmd(x)
%%%%%Am_d��ֵ����
%%%%%Fm_d��Ƶ����
%%%%%xԭʼ�ź�
%%%%%n�ֽ��źŵĽ�����Ҳ���Բ����ã�Ĭ�Ͼ��Ƿֽ⵽���һ�㣬��ʱ��ʱ������
n=length(x);
temp_x=x;
%%%%%�����ֲ���ֵ
[inmin inmax inzero]=extr(x);
[tmin,tmax,zmin,zmax]=boundary_conditions(inmin,inmax,1:n,x,x,2);%%%%�˵�����

%%%%%���ֲ���ֵ�Ͱ���
[localMaxMin indexTemp]=CombinMaxMin(tmin,tmax,zmin,zmax);
[local_mean local_en index]=LocalMeanEn(localMaxMin,indexTemp);

%%%%%����Ӧ�����ƶ�ƽ�������ֲ���ֵ���������ﻹ������cubic������������
interpl.method='cubic';%%%%��ͬ���������������ﻻ
LocalMeanFun=interp1(index,local_mean,1:n,interpl.method);
LocalEnFun=interp1(index,local_en,1:n,interpl.method);
Am_d=LocalEnFun;
hhhtt_tt=x-LocalMeanFun;
ssstt_tt=hhhtt_tt./LocalEnFun;

%%%%%�ж�ssstt_tt�ǲ��Ǵ���Ƶ�ź�
flag=1;
Delta_delta=1e-6;
temp_ss=find(ssstt_tt>1+Delta_delta | ssstt_tt<-1-Delta_delta);
[LineSize ColumnSize]=size(temp_ss);
flag=ColumnSize;
%%%CounterSize=1;
while flag %%%& CounterSize<100
    
    x=ssstt_tt;
    %%%%%�����ֲ���ֵ
   [inmin inmax inzero]=extr(x);
   [tmin,tmax,zmin,zmax]=boundary_conditions(inmin,inmax,1:n,x,x,2);%%%%�˵�����

   %%%%%���ֲ���ֵ�Ͱ���
   [localMaxMin indexTemp]=CombinMaxMin(tmin,tmax,zmin,zmax);
   [local_mean local_en index]=LocalMeanEn(localMaxMin,indexTemp);

   %%%%%����Ӧ�����ƶ�ƽ�������ֲ���ֵ���������ﻹ������cubic������������
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

