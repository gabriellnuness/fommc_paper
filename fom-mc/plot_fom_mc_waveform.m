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
fileName1 = 'fom-mc-waveform-30Hz.csv';
fileName2 = 'fom-mc-waveform-150Hz.csv';
figure_size = [10 5];
font_size = 11; 
c = [.3 .3 .3];


% Reading data
data = csvread(fileName1,2,0); %starts from 3rd line (0,1,2,...)
time = data(:,1);
time1 = time-time(1);
input1= data(:,4);
interf1 = data(:,3);
control1 = data(:,2);

% Reading data
data = csvread(fileName2,2,0); %starts from 3rd line (0,1,2,...)
time = data(:,1);
time2 = time-time(1);
input2= data(:,4);
interf2 = data(:,3);
control2 = data(:,2);
%% Plot of overall data info     
% 30 Hz  
figure('Units','centimeter','Position',[0 1 20 15],...
    'PaperPositionMode','auto')
subplot(3,2,1)
   plot(time1,input1)
subplot(3,2,2)
  plot(time1,interf1)
subplot(3,2,3)
    plot(time1,control1)
subplot(3,2,4)
    FFT_plot(time1,interf1,[0.3 0.3 0.3]) %signal,time,color
% Lissajous curve
subplot(3,2,5)
    plot(input1,interf1)
    axis('equal')
% 150 Hz    
figure('Units','centimeter','Position',[0 1 20 15],...
    'PaperPositionMode','auto')
subplot(3,2,1)
   plot(time2,input2)
subplot(3,2,2)
  plot(time2,interf2)
subplot(3,2,3)
    plot(time2,control2)
subplot(3,2,4)
    FFT_plot(time2,interf2,[0.3 0.3 0.3]) %signal,time,color
% Lissajous curve
subplot(3,2,5)
    plot(input2,interf2)
    axis('equal')

%% Plot waveforms for paper
% plot input vs output 30 Hz
in = input1; %volts
out = interf1; %volts
t = time1;

figure('Units','centimeter','Position',[0 1 figure_size],...
    'PaperPositionMode','auto')
subplot(2,1,1)
plot(t,in,'Color',c)
    ylim([13 27])
    ref_label = ylabel('Input [V]','Interpreter','latex');
    set(gca,'FontSize',font_size)
	xlim([0 0.2])
       
subplot(2,1,2)
plot(t,out,'Color',c)
    xlabel('Time [s]','Interpreter','latex')
    label_2 = ylabel('Output [V]','Interpreter','latex');
    set(gca,'FontSize',font_size)
	xlim([0 0.2])
    ylim([0 10])

%     label_2.Position(1) = -1.2758;

% plot input vs output 150 Hz
in = input2; %volts
out = interf2; %volts
t = time2;

figure('Units','centimeter','Position',[0 1 figure_size],...
    'PaperPositionMode','auto')
subplot(2,1,1)
plot(t,in,'Color',c)
    ylim([13 27])
    ref_label = ylabel('Input [V]','Interpreter','latex');
    set(gca,'FontSize',font_size)
	xlim([0 0.1])
   
subplot(2,1,2)
plot(t,out,'Color',c)
    xlabel('Time [s]','Interpreter','latex')
    label_2 = ylabel('Output [V]','Interpreter','latex');
    set(gca,'FontSize',font_size)
	xlim([0 0.1])
    ylim([4 6])
%     ylim([2 8])
%     label_2.Position(1) = -1.2758;

%%
set(figure(3),'paperunits','centimeters',...
    'paperposition',[0 0  figure_size]);
set(figure(3), 'PaperSize', figure_size);
set(figure(4),'paperunits','centimeters',...
    'paperposition',[0 0  figure_size]);
set(figure(4), 'PaperSize', figure_size);

print(figure(3),'fom-mc-waveform_30_Hz.eps','-loose','-depsc')
print(figure(3),'fom-mc-waveform_30_Hz.png','-loose','-dpng')
print(figure(4),'fom-mc-waveform_150_Hz.eps','-loose','-depsc')
print(figure(4),'fom-mc-waveform_150_Hz.png','-loose','-dpng')









