clear                                                                      %%%% It will clear all the variables from the workspace
clc                                                                        %%%% It will clear all the texts from command window
close all                                                                  %%%% It will close all the previous figures

addpath('G:\My Drive\Grad_School_Year_3\MATLAB_Bootcamp\pni-summer-matlab-2021\Week_5');%%%% path where this MATLAB code file is present
cd('G:\My Drive\Grad_School_Year_3\MATLAB_Bootcamp\pni-summer-matlab-2021\Week_5');     %%%% path where the data file from LABCHART is present

%%%%%%%%%%%%%%%%%%%%%% Loading the data file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('nerve_data_example_2.mat');                       %%%% Load the data file 
data=nerve_voltage;                              
data(:,2)=-1*data(:,2);
%%%%%%%%%%%%%%%%%%%%%%%% Plotting raw data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure; 
plot(data(:,1),data(:,2),'-r')                                     %%%% Plotting Raw data
xlabel('Time (sec)','fontsize',14);                                  %%%% Writing x label. The fontsize of the label is also mentioned.
ylabel('Voltage (uV)','fontsize',14);                               %%%% writing y label
title('Raw data');                                                         %%%% Writing the title of the plot
box off;                                                                    %%%% Box off does not make a square around the figure
set(gca,'fontsize',14)                                                     %%%% This will set the font size of tick labels to be 14
%%
%%%%%%%%%%%%%%%% Determining peaks based on threshold %%%%%%%%%%%%%%%%%%%%
[pks,locs,widths] = findpeaks(data(:,2),'MinPeakHeight',50,'MinPeakDistance',40); %%%% Peak threshold, and minimum inter peak distance
figure; 
plot(data(:,1),data(:,2),'m', 'linewidth',1)  
hold on
plot(data(locs),pks,'ob')%%%% Highlighting peaks above threshold
xlabel('Time (sec)','fontsize',14); 
ylabel('Voltage (uV)','fontsize',14);
title('Peaks above threshold');
box off;
set(gca,'fontsize',14)
%%
%%%%%%%%%%%%%%% Plotting histogram of peak height %%%%%%%%%%%%%%%%%%%%%%%%
figure;
peaks_hist = histogram(pks);                                            %%%% pks has all the amplitude information of the AP peaks
peaks_hist.BinWidth = 10;                                                %%%% Binwidth is the width of each histogram bin
xlabel('Amplitude of AP (uV)','fontsize',14);
ylabel('Number of occurences','fontsize',14)                             
title('Histogram of AP amplitude','fontsize',14);
box off; 
set(gca,'fontsize',14)
%%
%%%%%%%%%%%%%%% Plotting histogram of peak widths %%%%%%%%%%%%%%%%%%%%%%%%%
figure;                                                   
width_hist = histogram(widths);                                         %%%% widths has all the width information of the AP peaks
width_hist.BinWidth = 0.05;                                              
xlabel('Width of AP (ms)','fontsize',14);
ylabel('Number of occurences','fontsize',14)                             
title('Histogram of AP width','fontsize',14);
box off; 
set(gca,'fontsize',18)

%% 
figure
plot(widths,pks,'ob')
xlabel('Width of AP (ms)','fontsize',14);
ylabel('Amplitude of AP (uV)','fontsize',14)                             
title('width vs amplitude of spikes','fontsize',14);
box off; 
set(gca,'fontsize',18)
%%
%%%%%%% finding the location of peaks with same height
all_peak_200=[];
all_locs_200=[];

for i=1:size(pks,1)
    if pks(i,1)<200 && pks(i,1)>170
        all_peak_200=[all_peak_200 pks(i,1)];
        all_locs_200=[all_locs_200 locs(i,1)];
    end
end

%%