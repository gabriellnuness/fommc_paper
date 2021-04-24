% This script plots the nonlinear control actuation proccess 
% version: MATLAB 2019b
% Author: Gabriel Nunes

close all
clear
clc

set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')

% starting definitions
papersize = [21.0 29.7]; % width x height in cm
figsize = [papersize(1)/2 papersize(1)*0.375];
font_size = 10;
c = [0.3, 0.3, 0.3]; % color of the plots

%% Import File Section
filename = 'fom-pa-control-actuation.csv';

wave = readtable(filename);
header = wave(1:2,:)

time = str2double(wave.Var1(3:end));

v1 = str2double(wave.Var2(3:end));
v2 = str2double(wave.Var3(3:end));
v3 = str2double(wave.Var4(3:end));

% treating signal
time = time-time(1);
time = time - 0.5; % translating plot

v2 = v2./2; % High Z oscilloscope and 50 Ohm Func. Gen.

control = v3.*50; % after Linear amplifier
v3 = control;


%% Plot Section
% two column paper 1 column figure

fig = figure('units','centimeter','position',[0 1  figsize]);

%%%%%%%%%%%%%% 1
subplot(3,1,1)
plot(time, v2*1000,'Color', c)

ylim([-0.05*1300 0.05*1300])
set(gca,'fontsize', font_size)
ref_label =  ylabel('Input [mV]','interpreter','latex');
xlim([0 3])
grid on
% ylabel reference position
label_position = get(ref_label,'position'); %[x y z]
ref_label.Position = [-0.26 6.1989e-05 -1];

%%%%%%%%%%%%%% 2
subplot(3,1,2)
hold on
plot(time, v1,'Color', c)
% Lines
plot([0.91-0.5 1.4-0.5], [max(v1) max(v1)],'-.k','linewidth', 0.5) %vpd max
plot([0.91-0.5 1.4-0.5], [min(v1) min(v1)],'-.k','linewidth', 0.5) %vpd min
plot([2.2-0.5 2.69-0.5], [7.63 7.63],'-.k','linewidth', 0.5) %vmax
plot([2.2-0.5 2.69-0.5], [2.56 2.56],'-.k','linewidth', 0.5) %vmin
title('')
xlim([0 3])
set(gca,'fontsize', font_size)
ylim([-2 13])
% aligning ylabel with ref
ref2_label = ylabel('$v_{PD}$ [V]','interpreter','latex');
ref2_label.Position = [-0.26 5.5000 -1.0000];
% texts
text(0.6-0.5-0.09,11.05+0.5,0,'${v_{PD}}_{\mathrm{max}}$',...
    'interpreter','latex','fontsize',10)
text(0.6-0.5-0.09,1+0.5,0,'${v_{PD}}_{\mathrm{min}}$',... 
    'interpreter','latex','fontsize',10)
text(1.65-0.5,5.5,0,'$v_\mathrm{max}{-}v_\mathrm{min}$',...
    'interpreter','latex','fontsize',10)
% arrows
arrow = annotation('doublearrow');
arrow.Parent = gca;
arrow.Position = [2.3-0.5, 2.56, 0, (7.63-2.56)] ;
arrow.Head1Width = 3;
arrow.Head2Width = 3;
arrow.Head1Length = 3;
arrow.Head2Length = 3;
grid on

%%%%%%%%%%%%%% 3
subplot(3,1,3)
plot(time, v3,'Color', c)
xlabel('Time [s]','interpreter','latex')
set(gca,'fontsize', font_size)
ylim([0 60])
xlim([0 3])
% algining ylabel with ref
ref3_label = ylabel('Control [V]','interpreter','latex');
ref3_label.Position = [-0.26 30 -1];
grid on

%% Save Section

set(gcf,'paperunits','centimeters','paperposition',[0 0 figsize]);
set(gcf, 'PaperSize', figsize);
print(gcf,'fom-pa-control-actuation','-dpng')
print(gcf,'fom-pa-control-actuation','-depsc')

















