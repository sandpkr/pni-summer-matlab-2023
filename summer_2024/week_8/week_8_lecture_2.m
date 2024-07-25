clear
clc
close all

load('width_vs_peaks_data.mat')

num_clusters = 4;

[idx, C] = kmeans(width_vs_peaks_data, num_clusters);
color_group=[1 0 0; 0 1 0; 0 0 1; 1 0 1];

figure;
scatter(width_vs_peaks_data(:,1), width_vs_peaks_data(:,2),25,color_group(idx,:));
hold on;
% plot(C(:,1), C(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 3);
title('K-means Clustering');
xlabel('Width','FontSize',20);
ylabel('Amplitude','FontSize',20);
set(gca,'FontSize',20)
hold off;
