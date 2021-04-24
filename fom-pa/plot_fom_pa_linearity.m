% This script plots the linearity of a modulator in a chosen frequency and
% fits the data to a line.
%
% Version: MATLAB 2019b
% Author: Gabriel Nunes


set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
clear all
close all
clc

figure_size = [10 7];
axis_font_size = 11;
leg_font_size = 10;
%% Calculation

% In this case, the data set is small and is already inside the script
Vmax = 10.2;
Vmin = 0.5;
data = [50,6.1,4.1
        60,6.25,3.9
        70,6.45,3.78
        80,6.60,3.59
        90,6.77,3.42
        100,6.9,3.27
        100,6.9,3.27
        90,6.78,3.41
        80,6.6,3.6
        70,6.41,3.75
        60,6.26,3.95
        50,6.07,4.1];
    
    Vin = data(:,1); % mV
    Vin = Vin/1000; % V
    rad = (data(:,2) - data(:,3))./((Vmax-Vmin));

% fitting
x = Vin;
y = rad;
[f,s] = fit(x,y,'poly1');
Rsqr = s.rsquare;
fit_slope = f.p1  % rad/V
fit_intercept = f.p2; 
    
    %% Plot second axis with strain units
 figure('Units','centimeter','Position',[0 1 figure_size],...
           'PaperPositionMode','auto')
    
    
%     yyaxis left
plot(Vin,rad,'.k')
    hold on
p = plot(f);
    xlabel('Input amplitude [V]','Interpreter','Latex','FontSize',10)
    ylabel('Output [rad]','Interpreter','Latex','FontSize',10)
    leg = legend('1 kHz',['$y=$',num2str(f.p1,2),'$\cdot x+$',num2str(f.p2,2)],'Location','NorthWest',...
            'Interpreter','Latex');
    leg.FontSize = leg_font_size;
    ylim([0.1 max(rad)+0.1])
    set(p,'Color',[.3 .3 .3])
    set(gca,'YColor','k')
    xlim([min(Vin)-0.001 max(Vin)+0.001])
    set(gca,'fontsize',axis_font_size)
    grid on
    ax = gca;
    ax.XRuler.MinorTick = 'on';
    ax.YRuler.MinorTick = 'on';
    
 %%
paperunits='centimeters';

set(gcf,'paperunits',paperunits,'paperposition',[0 0 figure_size]);
set(gcf, 'PaperSize', figure_size);

print(gcf, 'linearity_pzt.png','-loose','-dpng')
print(gcf, 'linearity_pzt.eps','-loose','-depsc')
    
    
    
    
    
    
    
    
    