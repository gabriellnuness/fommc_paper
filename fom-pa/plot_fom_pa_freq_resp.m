% FOM-PA
% This script calculates the scale factor of a modulator by using 
% the interferometer signal working with a low-index modulation siignal.
% The data was acquired with a LabVIEW automation of the function generator
% and the Oscilloscope with GPIB connection.
% The input voltage is reduced until an output signal with
% 3% total harmonic distortion is achieved (low-index modulation). 
%
% This script uses the ShadedErrorBar function by: 
% Rob Campbell (2021). raacampbell/shadedErrorBar (https://github.com/raacampbell/shadedErrorBar), GitHub. Retrieved April 24, 2021.
%
% Version: MATLAB 2019b
% Author: Gabriel Nunes


set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
clear all
close all
clc

%% Constants definition
axis_font_size = 11;
inset_font_size = 10;
figure_size = [10 7]; % [cm]

%% Data import into cells

% load .mat files containing AV values (A + AV cos(Dphi))
num_acq = 2; 
for i=1:num_acq
    av{i} = strcat(num2str(i),'AV-fom-pa.mat');
    load(av{i});
   if i==1
       v1 = V1;
       v2 = V2;
   else
    v1 = vertcat(v1,V1);
    v2 = vertcat(v2,V2);
   end
end

% Collection of data in cell format, it is almost like a 3D array.
% 'fom-pa-freq-resp_' is the pattern name of the files
i=1;
while exist(['fom-pa-freq-resp_',num2str(i),'.lvm'], 'file') == 2 % while file exists
    filename = ['fom-pa-freq-resp_',num2str(i),'.lvm'];

    data{i} = dlmread(filename);
    Vmax{i} = data{i}(:,1); % Max amp in low index modulation
    Vmin{i} = data{i}(:,2); % Min amp in low index modulation
    phase{i} = data{i}(:,3); % Phase delay between Input and Output
    % conditioning phase
    for n=1:length(phase{i})-1   
        if phase{i}(n)>180 & phase{i}(n)<360
            phase{i}(n) = phase{i}(n) -360;
        end
    end
    Vin{i} = data{i}(:,4);     % voltage input from func generator
     % conditioning Vin accordingly to experiment
    for n=1:length(Vin{i})-1
        % Min voltage possible provided by func.gen. is 50 mV
        if Vin{i}(n)<0.05   
            Vin{i}(n) = 0.05;
        end
        % error value from LabVIEW trying Vin < 50 mV
        if Vin{i}(n) == [1.38777900000000e-17]
            Vin{i}(n)= 0.05;
        end
    end

    Freq{i} = data{i}(:,5); % Frequency of input signal
    error{i} = data{i}(:,6); % flag = 1 if Vin= 50 mV and THD>3%
    THD{i} = data{i}(:,7); % Harmonic Distortion in interferometric signal

    % AV valued with frequency applied.
    % It is not accurate, though. To speed up the proccess, the starting input
    % voltage was not always high enough to reach multi fringes.
    Vr1{i} = data{i}(:,8); % Vmax with frequency applied 
    Vr2{i} = data{i}(:,9); % Vmax with frequency applied

    i=i+1;
end
noffiles = length(data) % number of files in this automation

%% Demodulation and data plot

figure('Units','centimeter','Position',[10 10 14 10.5],'PaperPositionMode','auto')
figure('Units','centimeter','Position',[25 10 14 10.5],'PaperPositionMode','auto')

for i=1:noffiles

A = (v1(i) + v2(i))/2;
V = (v1(i) - v2(i))/(2*A);

% experiment info
fiber_length = 10.172; % m
lambda = 1536; % nm

% low-index signal recover math
x{i} = (abs(Vmax{i} - Vmin{i}))./(2*A*V);
gain{i} = x{i}./Vin{i}; % [rad/V]
L{i}= gain{i}*lambda./(4*pi);
F{i} = Freq{i}/1000; % [kHz]
scale_factor{i} = gain{i}./fiber_length; % [rad/V/m]

% all data plot
figure(1)
plot(F{i},gain{i},'.-','DisplayName',['data',num2str(i)])
xlabel('Frequency [kHz]','Color','k','interpreter','LaTeX');
ylim([0 8])
ylabel('Scale Factor [rad/V]','Color','k','interpreter','LaTeX');
legend('-DynamicLegend');
grid
hold all

figure(2)
plot(F{i},phase{i},'.-','DisplayName',['data',num2str(i)])
ylim([-180 180])
xlabel('Frequency [kHz]','Color','k','interpreter','LaTeX');
ylabel('Phase [degree]','Color','k','interpreter','LaTeX');
legend('-DynamicLegend');
hold all
grid

end


%% Mean and Standard Deviation

% converting from cell to matrix
for i=1:10
    m_gain(:,i) = gain{i};
    m_phase(:,i) = phase{i};
    m_length(:,i) = scale_factor{i};
end

for i=1:length(m_gain)
    mean_gain(i) = mean(m_gain(i,:));
    std_gain(i) = std(m_gain(i,:));
end
mean_gain = mean_gain';    % transposing to column array
std_gain = std_gain';

for i=1:length(m_phase)
    mean_phase(i) = mean(m_phase(i,:));   
    std_phase(i) = std(m_phase(i,:));    
end
mean_phase = mean_phase';      
std_phase = std_phase';

for i=1:length(m_length)
    mean_length(i) = mean(m_length(i,:));  
    std_length(i) = std(m_length(i,:));    
end
mean_length = mean_length';      
std_length = std_length';

% The data was acquired in 2 parts
% from 50Hz to 500 Hz with smaller freq step and 
% from 500 Hz to 5 KHz

% Mean and Standard Deviation for 2nd data set 
for i=1:10
    mm_gain(:,i) = gain{i+10}; 
    mm_phase(:,i) = phase{i+10};
    mm_length(:,i) = scale_factor{i+10};
end

for i=1:length(mm_gain)
    mean_gain2(i) = mean(mm_gain(i,:));  
    std_gain2(i) = std(mm_gain(i,:));    
end
mean_gain2 = mean_gain2';        
std_gain2 = std_gain2';

for i=1:length(mm_phase)
    mean_phase2(i) = mean(mm_phase(i,:));   
    std_phase2(i) = std(mm_phase(i,:));     
end
mean_phase2 = mean_phase2';       
std_phase2 = std_phase2';

for i=1:length(mm_length)
    mean_length2(i) = mean(mm_length(i,:));   
    std_length2(i) = std(mm_length(i,:));     
end
mean_length2 = mean_length2';       
std_length2 = std_length2';

% Concatenating the data sets
mean_gain = [mean_gain ; mean_gain2];
mean_phase = [mean_phase ; mean_phase2];
mean_length = [mean_length ; mean_length2];

std_gain = [std_gain ; std_gain2];
std_phase = [std_phase ; std_phase2];
std_length = [std_length ; std_length2];

freq = [F{1};F{11}];

%% Plot figures with error shaded area
figure('Units','centimeter','Position',[10 10 figure_size],...
    'PaperPositionMode','auto')
shadedErrorBar(freq,mean_gain,std_gain,'lineprops','-k')
    ylim([0 10])
    xlim([0 5.1])
    xlabel('Frequency [kHz]','Color','k','interpreter','LaTeX');
    label_1 = ylabel('Scale factor [rad/V]','Color','k','interpreter','LaTeX');
    set(gca,'YMinorTick','on')
    set(gca,'XMinorTick','on')
    set(gca,'FontSize',axis_font_size)
        
    % getting the tick marks and converting to the y-right axis units
    L = fiber_length; 
    ax = gca;
    rad_v = ax.YTick; % ticks from yyaxis left
    rad_v_m = rad_v/L;
    rad_v_m = round(rad_v_m,2);
    rad_v_m = num2str(rad_v_m, '%.2f    ');%to number
    rad_v_m = strsplit(rad_v_m); %converting each string to cell
    lim = ax.YLim

    yyaxis right
    set(gca,'YColor','k')
    set(gca,'YLim',lim)
    set(gca,'YTickLabel',rad_v_m)
    ylabel('Normalized scale factor[rad/V/m]','Color','k','interpreter','LaTeX');
    grid
    box on
    set(gca,'YMinorTick','on')
    set(gca,'XMinorTick','on')
    ax1 = gca;
    set(gca,'FontSize',axis_font_size)

figure('Units','centimeter','Position',[25 10 figure_size],...
    'PaperPositionMode','auto')
shadedErrorBar(freq,mean_phase,std_phase,'lineprops','-k')
    ylim([-180 180])
    xlabel('Frequency [kHz]','Color','k','interpreter','LaTeX');
    label_2 = ylabel('Phase [degree]','Color','k','interpreter','LaTeX');
    label_2.Position(1) = label_2.Position(1) +0.01;
    grid on
    box on
    set(gca,'YMinorTick','on')
    set(gca,'XMinorTick','on')
    
% Forcing the two figures boxes to have the same size
ax2 = gca;
pos=get(ax1,'position');
set(ax2,'position',pos);

set(gca,'FontSize',axis_font_size)
%% Post processing the figures

clear ax ax1 ax2 rad_v rad_v_m
%% Making inset from 50Hz to 200 Hz
figure(3)
axes('position',[.310 .550 .40 .35])%.350 .550 .40 .35
box on

ax1 = shadedErrorBar(freq*1000, mean_gain, std_gain,...
    'lineprops','-k');
    xlabel('[Hz]','Color','k','interpreter','LaTeX');
    ylabel('[rad/V]','Color','k','interpreter','LaTeX');
    xlim([50 200])
    set(gca,'FontSize',inset_font_size)
    set(gca,'YMinorTick','on')
    set(gca,'XMinorTick','on')
     
    
    L = fiber_length; 
    ax = gca;
    rad_v = ax.YTick; % ticks from yyaxis left
    rad_v_m = rad_v/L;
    rad_v_m = round(rad_v_m,2);
    rad_v_m = num2str(rad_v_m, '%.2f    ');%to number
    rad_v_m = strsplit(rad_v_m); %converting each string to cell
    lim = ax.YLim

    yyaxis right
    set(gca,'YColor','k')
    xlim([50 200])
    set(gca,'YLim',lim)
    set(gca,'YTickLabel',rad_v_m)
    ylabel('[rad/V/m]','Color','k','interpreter','LaTeX');
    grid on
    grid minor
    set(gca,'YMinorTick','on')
    set(gca,'XMinorTick','on')
    set(gca,'FontSize',inset_font_size)
       
%% Save figures

paperunits='centimeters';

set(figure(3),'paperunits',paperunits,...
              'paperposition',[0 0 figure_size],...
              'PaperSize', figure_size);
set(figure(4),'paperunits',paperunits,...
              'paperposition',[0 0 figure_size],...
              'PaperSize', figure_size);
          
% Loose is set to let white space in the right border          
print(figure(3), 'scale_factor_fom_pa.png','-loose','-dpng')
print(figure(3), 'scale_factor_fom_pa.eps','-loose','-depsc')

print(figure(4), 'phase_fom_pa.png','-loose','-dpng')
print(figure(4), 'phase_fom_pa.eps','-loose','-depsc')


















