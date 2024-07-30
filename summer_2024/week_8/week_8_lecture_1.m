clear
clc
close all

rng(1);
simulated_data = [randn(100,2) + 2; randn(100,2) - 2; randn(100,2) + [5, -5]];

num_clusters = 3;

[idx, C] = kmeans(simulated_data, num_clusters);

figure;
gscatter(simulated_data(:,1), simulated_data(:,2), idx);
% scatter(simulated_data(:,1), simulated_data(:,2));
hold on;
plot(C(:,1), C(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 3);
legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Centroids');
title('K-means Clustering (k=3)');
xlabel('Feature 1');
ylabel('Feature 2');
hold off;
