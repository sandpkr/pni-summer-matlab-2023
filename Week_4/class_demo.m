%%% demo 
clear
clc
close all

to_plot_data=randi([1,10],10,10);
x_data=1:1:10;

plot(to_plot_data(:,1),to_plot_data(:,2),'or')

%%
for i=1:10
    figure;
    plot(x_data,to_plot_data(i,:),'-o')
    title(num2str(i))
%     waitforbuttonpress
%     close all
end
