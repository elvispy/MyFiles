clear
close all

n=8000;
t=0:2*pi/n:2*pi;
x =cos(t);
y = sin(t);
a =figure;
plot(x,y,'k','LineWidth',4)
axis equal
hold on
t1 = 5*pi/4:2*pi/n:7*pi/4;
x1 = cos(t1);
y1 = sin(t1);
plot(x1,y1-.05,'color',[.3 .3 .3],'LineWidth',4)
hold on
t2 = 0:.001:5;
x2 = t2+x1(length(x1));
y2 = y1(length(y1))+(1-exp(-t2))-.05;
plot(x2,y2,'--','color',[.8 .8 .8],'LineWidth',2)%free surfaces
set(gca,'Xlim',[-1.5 1.5],'Xtick',[],'Ytick',[])
hold on
x3 = -t2-x1(length(x1));
y3 = y1(length(y1))+(1-exp(-t2))-.05;
plot(x3,y3,'--','color',[.8 .8 .8],'LineWidth',2)%free surfaces
hold on
% % % fill([x1,x1(1)],[y1,y1(1)],[.3 .3 .3])
% % % hold on
plot([.7 1.15],[-1.1 -1.1],'k')%bottom measure transporter for h
hold on
plot([x1(1),-x1(1)],[-1.1 -1.1],'--','color',[0 0 0],'LineWidth',4)
% hold on
% plot([0 cos(pi/20) cos(pi/20)+cos(pi/20+9*pi/10)*.15 cos(pi/20) cos(pi/20)+cos(pi/20-9*pi/10)*.15],[0 sin(pi/20) sin(pi/20)+sin(pi/20+9*pi/10)*.15 sin(pi/20) sin(pi/20)+sin(pi/20-9*pi/10)*.15],'k')
% TextBoxr = uicontrol('style','text')
% set(TextBoxr,'Units','characters','FontSize',16)
% set(TextBoxr,'String','R')
% set(TextBoxr,'Position',[55,20,3,1.5])
% set(TextBoxr,'BackgroundColor',[1 1 1])
% 
% TextBox0 = uicontrol('style','text')
% set(TextBox0,'Units','characters','FontSize',16)
% set(TextBox0,'String','0')
% set(TextBox0,'Position',[57.5,19.6,1.6,1.5])
% set(TextBox0,'BackgroundColor',[1 1 1])
hold on
plot([0 -1.2],[-1 -1],'k')%bottom measure transporter for zs
hold on
plot([-cos(pi/6) -1.2],[-sin(pi/6) -sin(pi/6)],'k')%top measure transporter for zs
hold on
%arrows for zs
plot([-1.15 -1.15 -1.15+cos(pi/2+9*pi/10)*.15 -1.15 -1.15+cos(pi/2-9*pi/10)*.15 -1.15 -1.15 -1.15-cos(-pi/2+9*pi/10)*.15 -1.15 -1.15+cos(-pi/2+9*pi/10)*.15],[-1 -sin(pi/6) -sin(pi/6)+sin(pi/2+9*pi/10)*.15 -sin(pi/6) -sin(pi/6)+sin(pi/2+9*pi/10)*.15 -sin(pi/6) -1 -1+sin(-pi/2+9*pi/10)*.15 -1 -1+sin(-pi/2+9*pi/10)*.15],'k')

TextBoxz = uicontrol('style','text');
set(TextBoxz,'Units','characters','FontSize',16)
set(TextBoxz,'String','z  (r)')
set(TextBoxz,'Position',[14,8.75,6,1.5])
set(TextBoxz,'BackgroundColor',[1 1 1])

TextBoxs = uicontrol('style','text');
set(TextBoxs,'Units','characters','FontSize',16)
set(TextBoxs,'String','s')
set(TextBoxs,'Position',[15.6,8.65,1.6,1.2])
set(TextBoxs,'BackgroundColor',[1 1 1])

TextBoxS = uicontrol('style','text');
set(TextBoxS,'Units','characters','FontSize',16)
set(TextBoxS,'String','S')
set(TextBoxS,'Position',[69,8.55,2,1.5])
set(TextBoxS,'BackgroundColor',[1 1 1])
%text('\rho, r_{c}', 'Interpreter', 'latex')

TextBoxcs = uicontrol('style','text');
set(TextBoxcs,'Units','characters','FontSize',16)
set(TextBoxcs,'String','c')
set(TextBoxcs,'Position',[70.9,8.35,1.3,1.3])
set(TextBoxcs,'BackgroundColor',[1 1 1])

TextBoxA = uicontrol('style','text');
set(TextBoxA,'Units','characters','FontSize',16)
set(TextBoxA,'String','A')
set(TextBoxA,'Position',[23,4.1,2,1.5])
set(TextBoxA,'BackgroundColor',[1 1 1])

TextBoxca = uicontrol('style','text');
set(TextBoxca,'Units','characters','FontSize',16)
set(TextBoxca,'String','c')
set(TextBoxca,'Position',[24.9,4,1.3,1.3])
set(TextBoxca,'BackgroundColor',[1 1 1])

hold on

plot([.85 .65 .75 .65 .65+.08743],[-.8 -.85 -.85 -.85 -.85+0.04854],'k')

plot([-.95 -.73 -.8238 -.73 -.73-.11],[-1.17 -1.105 -1.1624 -1.105 -1.105],'k')

plot([0 1.15],[-1 -1],'k')%top measure transporter for h
plot([1.1 1.1],[-1 -1.1],'k')%measure mark for h

plot([0 0 0 .975*sqrt(2)/2 .97*sqrt(2)/2-.1*cos(15*pi/180) .97*sqrt(2)/2 .97*sqrt(2)/2-.1*cos(15*pi/180) .97*sqrt(2)/2],...
    [-1.175 -1.225 -1.2 -1.2 -1.2+.1*sin(15*pi/180) -1.2 -1.2-.1*sin(15*pi/180) -1.2],'k')

TextBoxr = uicontrol('style','text');
set(TextBoxr,'Units','characters','FontSize',16)
set(TextBoxr,'String','r')
set(TextBoxr,'Position',[54.5,4,2,1.5])
set(TextBoxr,'BackgroundColor',[1 1 1])

TextBoxcr = uicontrol('style','text');
set(TextBoxcr,'Units','characters','FontSize',16)
set(TextBoxcr,'String','c ')
set(TextBoxcr,'Position',[56.4,3.9,2,1.4])
set(TextBoxcr,'BackgroundColor',[1 1 1])

TextBoxq = uicontrol('style','text');
set(TextBoxq,'Units','characters','FontSize',16)
set(TextBoxq,'String','h(t)')
set(TextBoxq,'Position',[76,5.45,6,1.5])
set(TextBoxq,'BackgroundColor',[1 1 1])

% hold on
% plot([.95 .95],[-1.1 -.54145],'k')
% 
% TextBoxq = uicontrol('style','text')
% set(TextBoxq,'Units','characters','FontSize',16)
% set(TextBoxq,'String','\eta')
% set(TextBoxq,'Position',[78,5.5,4,1.5])
% set(TextBoxq,'BackgroundColor',[1 1 1])

print(a,'-depsc','-r300','Scheme.eps')











