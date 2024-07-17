clear
clc
close all

load('action_potential_cropped.mat')
load('velocity_array.mat')

data(:,2)=-1*velocity_array(1,:);
data(:,1)=[1:1:size(data(:,2),1)];

% figure;
% plot(data(:,1),data(:,2),'-b')
% xlim([0 300])

[pks,locs,widths] = findpeaks(data(:,2),'MinPeakHeight',-0.1); %%%% Peak threshold, and minimum inter peak distance
% [pks,locs,widths] = findpeaks(data(:,2),'MinPeakHeight',-0.1,'MinPeakDistance',50); %%%% Peak threshold, and minimum inter peak distance
% [pks,locs,widths,proms] = findpeaks(data(:,2),'MinPeakHeight',-0.1,'MinPeakDistance',50,'MinPeakProminence',0.04); %%%% Peak threshold, and minimum inter peak distance


figure; 
plot(data(:,1),data(:,2),'b', 'linewidth',1)  
hold on
plot(data(locs),pks,'or','MarkerFaceColor','r')%%%% Highlighting peaks above threshold
xlim([data(1,1) data(end,1)])
xlabel('Time (sec)','fontsize',14); 
ylabel('Voltage (uV)','fontsize',14);
title('Peaks above threshold');
box off;
set(gca,'fontsize',14)
