% FOM-MC 
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
figure_size = [10 7];

%% Data import into cells


load AV-fom-mc.mat % file containing AV values
%collection of data in cell format, it is almost like a 3D array.
i=1;
%'data' is the default name of the files from 1 to infinite
while exist(['fom-mc-freq-resp_',num2str(i),'.lvm'], 'file') == 2 %while file exists
    
    filename = ['fom-mc-freq-resp_',num2str(i),'.lvm'];
    
    data{i} = dlmread(filename);  
    Vmax{i} = data{i}(:,8); % Max amp in low index modulation
    Vmin{i} = data{i}(:,9); % Min amp in low index modulation
    phase{i} = data{i}(:,3); % Phase delay between Input and Output
    %conditioning phase
    for n = 1:length(phase{i})-1   
        if phase{i}(n)>180 & phase{i}(n)<360
        phase{i}(n) = phase{i}(n) - 360;
        end
    end
    
    Vin{i} = data{i}(:,4);     % Voltage from func generator
    %conditioning Vin accordingly to experiment
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
    Vr1{i} = data{i}(:,1); % Vmax with frequency applied 
    Vr2{i} = data{i}(:,2); % Vmax with frequency applied

    i=i+1;
end
noffiles = length(data) % number of files in this automation



%% Demodulation and data plot

figure('Units','centimeter','Position',[10 10 14 10.5],'PaperPositionMode','auto')
figure('Units','centimeter','Position',[25 10 14 10.5],'PaperPositionMode','auto')

% experiment info
fiber_length = 10/1000; % m
lambda = 1536; % nm

for i=1:noffiles
    
    %V1 = Vpd_max, V2 = Vpd_min  (AV info)
    x{i} = (Vmax{i} - Vmin{i}) / (V1(i) - V2(i));  
    gain{i} = x{i}./ Vin{i}; % rad/V  
    L{i}= gain{i}*lambda./(4*pi); % nm
    F{i} = Freq{i}; %[Hz]
    scale_factor{i} = gain{i}./fiber_length; % rad/V/m

    % all data plot    
    figure(1)
    plot(F{i}, gain{i},'.-','DisplayName',['data',num2str(i)])
        hold all
        xlabel('Frequency [Hz]','Color','k','interpreter','LaTeX');
        ylabel('Scale Factor [rad/V]','Color','k','interpreter','LaTeX');
        legend('-DynamicLegend');
        grid

    figure(2)
    plot(F{i},phase{i},'.-','DisplayName',['data',num2str(i)])
        hold all
        ylim([-180 180])
        xlabel('Frequency [Hz]','Color','k','interpreter','LaTeX');
        ylabel('Phase [degree]','Color','k','interpreter','LaTeX');
        legend('-DynamicLegend');
        grid

end

%% Mean and Standard Deviation

% converting from cell to matrix
for i=1:noffiles
    m_gain(:,i) = gain{i}; 
    m_phase(:,i) = phase{i};
    m_length(:,i) = L{i};
end

% Scale factor in [rad/V]
for i=1:length(m_gain)
    mean_gain(i) = mean(m_gain(i,:));  
    std_gain(i) = std(m_gain(i,:));    
end
mean_gain = mean_gain'; % transposing to column array
std_gain = std_gain';

% Phase
for i=1:length(m_phase)
    mean_phase(i) = mean(m_phase(i,:));   
    std_phase(i) = std(m_phase(i,:));     
end
mean_phase = mean_phase';      
std_phase = std_phase';

% Physical length stretch
for i=1:length(m_length)
    mean_length(i) = mean(m_length(i,:));   
    std_length(i) = std(m_length(i,:));     
end
mean_length = mean_length';       
std_length = std_length';


%% Plot figures with error shaded area

figure('Units','centimeter','Position',[10 10 figure_size],...
    'PaperPositionMode','auto')
shadedErrorBar(F{1},mean_gain,std_gain,'lineprops','-k')
    xlabel('Frequency [Hz]','Color','k','interpreter','LaTeX');
    ylabel('Scale factor [rad/V]','Color','k','interpreter','LaTeX');
    ax = gca;
    ax.XRuler.MinorTick = 'on';
    ax.YRuler.MinorTick = 'on';
    hold all
    
yyaxis right
plot(F{1}, scale_factor{1},'Color','none')
    set(gca,'FontName','latex');
    xlim([F{1}(1) F{1}(end)])   
    right_label = ylabel('Normalized scale factor [rad/V/m]',...
        'Color','k','interpreter','LaTeX');
    set(gca,'YColor','k')
    set(gca,'FontSize',axis_font_size)
    right_label.Position(2) = right_label.Position(2)-0.01;
    right_label.Position(1) = right_label.Position(1)-1.5;
    
    ax=gca;
    r1=ax.YAxis(1);
    r2=ax.YAxis(2);
    ax.XRuler.MinorTick = 'on';
    ax.YRuler.MinorTick = 'on';

    grid on
    grid minor
    box on
    
figure('Units','centimeter','Position',[25 10 figure_size],...
    'PaperPositionMode','auto')
shadedErrorBar(F{1},mean_phase,std_phase,'lineprops','-k')
    ylim([-180 180])
    xlim([F{1}(1) F{1}(end)])   
    xlabel('Frequency [Hz]','Color','k','interpreter','LaTeX');
    xlim([F{1}(1) F{1}(end)])
    ylabel('Phase [degree]','Color','k','interpreter','LaTeX');
    grid on

    box on
    ax2 = gca;
    pos=get(ax,'position');
    set(ax2,'position',pos);
    ax = gca;
    ax.XRuler.MinorTick = 'on';
    ax.YRuler.MinorTick = 'on';
    set(gca,'FontSize',axis_font_size)

%% Save final plots

paperunits='centimeters';

set(figure(3), 'paperunits',paperunits,'paperposition',[0 0 figure_size]);
set(figure(3), 'PaperSize', figure_size);
set(figure(4), 'paperunits',paperunits,'paperposition',[0 0 figure_size]);
set(figure(4), 'PaperSize', figure_size);

print(figure(3), 'scale_factor_fom_mc.png','-loose','-dpng')
print(figure(3), 'scale_factor_fom_mc.eps','-loose','-depsc')
print(figure(4), 'phase_fom_mc.png','-loose','-dpng')
print(figure(4), 'phase_fom_mc.eps','-loose','-depsc')

    
%     
