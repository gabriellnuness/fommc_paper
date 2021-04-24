% Plot temperature characterization of FOM-MC


set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
close all
clear all
clc

%%
figure_size = [10 7];
legend_font_size = 10;
axis_font_size = 11;

%% Data import

% the data is in an MS Excel spreadsheet
V1 = xlsread('temp_fom_mc.xlsx','Plan1','A2:A14');
A1 = xlsread('temp_fom_mc.xlsx','Plan1','B2:B14')*10^-3;
T1 = xlsread('temp_fom_mc.xlsx','Plan1','C2:C14');

V2 = xlsread('temp_fom_mc.xlsx','Plan1','E2:E14');
A2 = xlsread('temp_fom_mc.xlsx','Plan1','F2:F14')*10^-3;
T2 = xlsread('temp_fom_mc.xlsx','Plan1','G2:G14');

V3 = xlsread('temp_fom_mc.xlsx','Plan1','I2:I14');
A3 = xlsread('temp_fom_mc.xlsx','Plan1','J2:J14')*10^-3;
T3 = xlsread('temp_fom_mc.xlsx','Plan1','K2:K14');

V4 = xlsread('temp_fom_mc.xlsx','Plan1','M2:M14');
A4 = xlsread('temp_fom_mc.xlsx','Plan1','N2:N14')*10^-3;
T4 = xlsread('temp_fom_mc.xlsx','Plan1','O2:O14');

V5 = xlsread('temp_fom_mc.xlsx','Plan1','Q2:Q14');
A5 = xlsread('temp_fom_mc.xlsx','Plan1','R2:R14')*10^-3;
T5 = xlsread('temp_fom_mc.xlsx','Plan1','S2:S14');

% The mean values and and standard deviation are calculated already.
Vmed = xlsread('temp_fom_mc.xlsx','Plan1','U2:U14');
Amed = xlsread('temp_fom_mc.xlsx','Plan1','V2:V14')*10^-3; %A
Tmed = xlsread('temp_fom_mc.xlsx','Plan1','W2:W14');

Vstd = xlsread('temp_fom_mc.xlsx','Plan1','Y2:Y14');
Astd = xlsread('temp_fom_mc.xlsx','Plan1','Z2:Z14');
Tstd = xlsread('temp_fom_mc.xlsx','Plan1','AA2:AA14');

%% Linear fit 

temperatureRange = find(Vmed > 15 & Vmed < 25);
data = [Vmed(temperatureRange),Tmed(temperatureRange)];
data = sortrows(data,1);
[aa,ss] = fit( data(:,1), data(:,2), 'poly1')

%% Figure
figure('Units','centimeter','Position',[10 10 figure_size],...
    'PaperPositionMode','auto')
    hold on    
errorbar(Vmed,Tmed,Tstd,'.k')
    xlim([15 25])
        
p = plot(aa);
    set(p,'color',[.3 .3 .3])
    ylim([20 60])
    xlim([-5 30])
    leg = legend('Data','Linear fit','location','northwest');%['$R^2$= ',num2str(ss.rsquare)]
    leg.FontSize = legend_font_size;
    box on
    grid
    xlabel('Voltage [V]','Interpreter','Latex');
    ylabel('Temperature [$^\circ$C]','Interpreter','Latex');
    set(gca,'YMinorTick','on')
    set(gca,'XMinorTick','on')
    set(gca,'fontsize',axis_font_size)
    
% converting tick marks from celsius to kelvin
convScale = 273.15; 
ax = gca;
celsius = ax.YTick; % ticks from yyaxis left
leftyaxis = celsius + convScale;
leftyaxis = num2str(leftyaxis);%to number
leftyaxis = strsplit(leftyaxis); %converting each string to cell
lim = ax.YLim;

yyaxis right
    set(gca,'YColor','k')
    set(gca,'YLim',lim)
    set(gca,'YTickLabel',leftyaxis)
    ylabel('Temperature [K]','Interpreter','Latex','Color','k');
    set(gca,'YMinorTick','on')
    set(gca,'XMinorTick','on')
    set(gca,'fontsize',axis_font_size)
%% Save figures

paperunits='centimeters';

set(gcf,'paperunits',paperunits,'paperposition',[0 0 figure_size]);
set(gcf, 'PaperSize', figure_size);
print(gcf,'temperature_fom_mc.png','-dpng');
print(gcf,'temperature_fom_mc.eps','-depsc');

