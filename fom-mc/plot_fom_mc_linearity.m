% This code calculates the linearity level of FOM-MC at 30 Hz and 150 Hz.
%
% Version: MATLAB 2019b
% Author: Gabriel Nunes

set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
clear all
close all
clc

%% Constants definition
figure_size = [10 7];
axis_font_size = 11;
legend_font_size = 10;
%% Data import

Vmax = 4.5;
Vmin = 0.22;
freq = [30;150];

for i = 1:2
    filename{i} = ['fom-mc-linearity_',num2str(freq(i)),'Hz.csv'];
    data = xlsread(filename{i});

    Vin{i} = data(:,1); % Volts
    Vsignal_max{i} = data(:,2);
    Vsignal_min{i} = data(:,3);
    rad{i} = (Vsignal_max{i} - Vsignal_min{i})./((Vmax-Vmin));

    % fitting
    x = Vin{i};
    y = rad{i};
    [f,s] = fit(x,y,'poly1');
    Rsqr{i} = s.rsquare;
    fit_slope{i} = f.p1;  % rad/V
    fit_intercept{i} = f.p2; 
    ff{i} = f;
end
fit_slope

%% Plot both graphs in same figure
figure('Units','centimeter','Position',[0 1 figure_size],...
       'PaperPositionMode','auto')
plot(Vin{1},rad{1},'.k')
    xlim([0.8, 5.2])
    hold on
p = plot(ff{1});
    set(p,'Color',[.3 .3 .3])
    set(gca,'YColor','k')
    
plot(Vin{2},rad{2},'*k', 'markersize',3)
    p = plot(ff{2},'--');
    set(p,'Color',[.3 .3 .3])
    set(gca,'YColor','k')
    leg = legend([num2str(freq(1)),' Hz'],['$y= $',num2str(ff{1}.p1,2),'$\cdot x+$',num2str(ff{1}.p2,2)],...
           [num2str(freq(2)),' Hz'],['$y= $',num2str(ff{2}.p1,2),'$\cdot x+$',num2str(ff{2}.p2,2)],...
        'Location','NorthWest','Interpreter','Latex');
    leg.FontSize = legend_font_size;
    leg.Position(2) = leg.Position(2)+0.025;
    xlabel('Input amplitude [V]','Interpreter','Latex')
    ylabel('Output [rad]','Interpreter','Latex')   
    set(gca,'Fontsize',axis_font_size)
    ax = gca;
    ax.XRuler.MinorTick = 'on';
    ax.YRuler.MinorTick = 'on';
    grid    
%%

paperunits='centimeters';

set(gcf,'paperunits',paperunits,'paperposition',[0 0 figure_size]);
set(gcf, 'PaperSize', figure_size)
print(gcf, 'fom-mc-linearity_30Hz_150Hz.png','-loose','-dpng')
print(gcf, 'fom-mc-linearity_30Hz_150Hz.eps','-loose','-depsc')
    
    
    
    
    
    
    
    
    
    
    