% This scripts plots the waveform of the input signal with the waveform of
% the output signal.
% 
% Version: MATLAB 2019b
% Author: Gabriel Nunes

clear all
close all
clc

set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')

% Constants definition
fileName = 'fom-pa-waveform_1kHz.csv';
figure_size = [10 5];
font_size = 11; 
c = [.3 .3 .3];

% Reading data
data = csvread(fileName,2,0); %starts from 3rd line (0,1,2,...)
time = data(:,1);
time = time-time(1);
input= data(:,2);
interf = data(:,3);
control = data(:,4);

%% Plot of overall data info     
figure('Units','centimeter','Position',[0 1 20 15],...
    'PaperPositionMode','auto')
subplot(3,2,1)
   plot(time,input)

subplot(3,2,2)
  plot(time,interf)

subplot(3,2,3)
    plot(time,control)

subplot(3,2,4)
    FFT_plot(time,interf,[0.3 0.3 0.3]) %signal,time,color

% Lissajous curve
subplot(3,2,5)
    plot(input,interf)
    axis('equal')

%% plot input vs output
in = input; %volts
out = interf; %volts
t = time;

figure('Units','centimeter','Position',[0 1 figure_size],...
    'PaperPositionMode','auto')

subplot(2,1,1)
plot(t*10^3,in*10^3,'Color',c)
    ylim([-150 150])
    ref_label = ylabel('Input [V]','Interpreter','latex');
    set(gca,'FontSize',font_size)
    xlim([0 10])
    
subplot(2,1,2)
plot(t*10^3,out,'Color',c)
    xlabel('Time [ms]','Interpreter','latex')
    label_2 = ylabel('Output [V]','Interpreter','latex');
    set(gca,'FontSize',font_size)
    xlim([0 10])
    ylim([2 8])
    label_2.Position(1) = -1.2758;

%%
set(gcf,'paperunits','centimeters','paperposition',[0 0  figure_size]);
set(gcf, 'PaperSize', figure_size);

print(gcf,'fom-pa-waveform_1kHz.eps','-loose','-depsc')
print(gcf,'fom-pa-waveform_1kHz.png','-loose','-dpng')











