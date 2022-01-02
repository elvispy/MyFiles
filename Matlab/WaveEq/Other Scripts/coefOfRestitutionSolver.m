
cd ../AxisSymmetricv_1.6/simulations/

simuls = dir('*.csv');
g = 9.80665e-3;
for ii = 1:length(simuls)
    clearvars -except simuls i g
    load(ii.name);
    jj = 1;
    contacted = false;
    while contacted == false || nnz(recordedPk) > 0
        if nnz(recordedPk) > 0 && contacted == false
            mS = 7.8 * 4 * pi * (rS.^3) / 3;
            contacted = true;
            Em_in = 1/2 * mS * ((v_k *)^2) + mS*g*z_k * Lunit; % Mechanical Energy In;
        end
        jj = jj+1;
    end
end

myFont = "Arial";
n=8000;
t=0:2*pi/n:2*pi;
x =cos(t);
y = sin(t);
a =figure;
plot(x,y,'k','LineWidth',4);
myax = gca; mypos = myax.Position;
axis equal
hold on
mylims = 1.5;
set(myax,'Xlim',[-mylims mylims],'Xtick',[],'Ytick',[]);


%S(t)
t1 = 5*pi/4:2*pi/n:7*pi/4;
x1 = cos(t1);
y1 = sin(t1);
plot(x1,y1-.05,'color',[.5, .5, .5], 'LineWidth', 5);%[0/256, 191/255, 255/255],'LineWidth',4)

%[xSt, ySt] = gca_to_Normalized(myax, [x1(1) - 0.25, x1(1) + 0.02], ...
%    [y1(1) + 0.02, y1(1)-0.12]);
[xSt, ySt] = gca_to_Normalized(myax, [x1(1) + 0.02, x1(1) + 0.29], ...
    [y1(1) - 0.28, y1(1)-0.30]);
annotation('textarrow', xSt, ySt, 'HeadLength', 10, ...
'HeadStyle', 'vback3', 'String', '$S(t)$', 'Interpreter', 'latex', ...
'LineWidth', 1.5, 'FontSize', 14);
hold on



% Free surfaces (eta)
t2 = 0:.001:20;
x2 = t2+x1(length(x1));
y2 = y1(length(y1))+(1-exp(-t2))-.05;
ZERO = -.1943;
CENTRE = 0;
plot(x2,y2,'color',[.5, .5, .5],'LineWidth',2)%free surfaces

x3 = -t2-x1(length(x1));
y3 = y1(length(y1))+(1-exp(-t2))-.05;
plot(x3,y3,'color',[.5, .5, .5],'LineWidth',2)%free surfaces
hold on


% z = 0
plot([-x2(end) x1(1)], [ZERO, ZERO], '--','color',[.8 .8 .8],'LineWidth',1);%free surfaces
aa = plot([x2(end) -x1(1)], [ZERO, ZERO], '--','color',[.8 .8 .8],'LineWidth',1);%free surfaces


%text(mylims-.45, ZERO + 16/200, "$z = 0$", ...
%    'Fontsize', 14, 'FontName', myFont, 'interpreter', 'latex')
%[xzt, yzt] = gca_to_Normalized(myax, [mylims - 0.2, mylims-.05] ...
%    , [ZERO+0.15, ZERO+0.01]);

% annotation('textarrow', xzt, yzt, ...
%     'HeadLength', 10, 'HeadStyle', 'vback3', 'String', '$z = 0$', ...
%     'Interpreter', 'latex', 'LineWidth', 1.5, 'FontSize', 14);

% A(t)
plot([x1(1),-x1(1)],[ZERO ZERO],'-.','color',[.3 .3 .3],'LineWidth',4);%'color',[0 0 0],'LineWidth',4)
[xAt, yAt] = gca_to_Normalized(myax, [x1(1), x1(1) + .25] ...
    , [ZERO + 0.15, ZERO+0.05]);
annotation('textarrow', xAt, yAt, ...
    'HeadLength', 10, 'HeadStyle', 'vback3', 'String', '$A(t)$', ...
    'Interpreter', 'latex', 'LineWidth', 1.5, 'FontSize', 14);

[leftxAt, leftyAt] = gca_to_Normalized(myax, [x1(1)+.01, x1(1)+.01] ...
    , [y1(1) + .05, ZERO-0.04]);
annotation('arrow', leftxAt, leftyAt, 'Color', [.7 .7 .7], ...
    'HeadLength', 15, 'HeadStyle', 'none', 'LineWidth', 1.5);
[rightxAt, rightyAt] = gca_to_Normalized(myax, [-x1(1)-.01, -x1(1)-.01] ...
    , [y1(1) + .05, ZERO-0.04]);
annotation('arrow', rightxAt, rightyAt, 'Color', [.7 .7 .7], ...
    'HeadLength', 15, 'HeadStyle', 'none', 'LineWidth', 1.5);

% h(t)
%Centre mark
val = 1/50;
plot([-val, val], [val, -val], 'k');
plot([-val, val], [-val, val], 'k');

plot([0.02 .16],[0 0],'Color', [.7 .7 .7], 'LineWidth', 1.1);%bottom measure transporter for h
[xht, yht] = gca_to_Normalized(myax, [.11 .11], [0, ZERO]);
annotation('doublearrow',xht, yht, ...
    'Head1Length', 7, 'Head2Length', 7, ...
    'Head1Style', 'vback3', 'Head2Style', 'vback3' ,'Linewidth',1 )
text(.16, ZERO/2, "$h(t)$", ...
    'Fontsize', 14, 'FontName', myFont, 'interpreter', 'latex')

%r_c(t)
plot([0 0],[0.02 0.16],'Color', [.7 .7 .7], 'LineWidth', 1.1);%bottom measure transporter for r_c(t)
[xrct, yrct] = gca_to_Normalized(myax, [0.01 -x1(1)-0.02], [.1,  .1]);
annotation('doublearrow',xrct, yrct, ...
    'Head1Length', 7, 'Head2Length', 7, ...
    'Head1Style', 'vback3', 'Head2Style', 'vback3' ,'Linewidth',1 );
[Xproyrct, Yproyrct] = gca_to_Normalized(myax, [-x1(1)-.01, -x1(1)-.01] ...
    , [.16, ZERO+0.07]);
annotation('arrow', Xproyrct, Yproyrct, 'Color', [.7 .7 .7], ...
    'HeadLength', 15, 'HeadStyle', 'none', 'LineWidth', 1.5);

text(-x1(1)/3, .2, "$r_c(t)$", ...
    'Fontsize', 14, 'FontName', myFont, 'interpreter', 'latex');

% C(t)
Ct = plot([x1(1)+.01, -x1(1)-0.01], [y1(1)-.05, y1(1)-.05], 'LineStyle', 'none', ...
    'Marker', 's', 'LineWidth', 1.5, 'Color', [.2 .2 .2], ...
    'MarkerSize', 13);

% L(t)
Lt = plot([x1(1)+.01, -x1(1)-0.01], [ZERO, ZERO], 'LineStyle', 'none', ...
    'Marker', '^', 'LineWidth', 1.1, 'Color', [.2 .2 .2], ...
    'MarkerSize', 8);

legend([Ct, Lt, aa], ["$C(t)$", "$L(t)$", "$z = 0$"], ...
    'FontSize', 11,  'interpreter', 'latex', 'AutoUpdate', 'off');

print(a,'-depsc','-r300','Scheme.eps')

function [X, Y] = gca_to_Normalized(ca, xs, ys)
    % (xs(i), ys(i)) represents a point. For annotation function, xs(1),
    % ys(1) represent the initial point of the annotation and xs(2), ys(2)
    % the final point. 
    pos = ca.Position;
    xLims = ca.XLim;
    yLims = ca.YLim;
    X = zeros(size(xs));
    Y = zeros(size(ys));
    for i = 1:length(xs)
       pctX = (xs(i) - xLims(1))/(xLims(2) - xLims(1)); 
       pctY = (ys(i) - yLims(1))/(yLims(2) - yLims(1));
       
       X(i) = pos(1) + pctX * pos(3);
       Y(i) = pos(2) + pctY * pos(4);
    end
end
