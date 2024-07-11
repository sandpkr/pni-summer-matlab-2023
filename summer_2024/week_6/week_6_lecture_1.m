clear
clc
close all

%%
rng(1)
data_1 = normrnd(4,2,[1,100]);
data_2 = normrnd(8,3,[1,100]);

%%
bin_widths=[-2:1:14];
figure
histogram(data_1,bin_widths,'FaceColor','r')
hold on;
histogram(data_2,bin_widths,'FaceColor','b')
xlabel('Data')
ylabel('Count')
set(gca,'FontSize',20)
box off
%%
[h,p]=ttest2(data_1,data_2);
%%
mean_data_1=mean(data_1);
mean_data_2=mean(data_2);
std_data_1=std(data_1);
std_data_2=std(data_2);

x_data=[1:2];
y_data=[mean_data_1,mean_data_2];
error_data=[std_data_1, std_data_2];

figure1=figure;
bar(x_data,y_data,'FaceColor','green')
hold on
errorbar(x_data,y_data,error_data,'LineStyle','none','LineWidth',2,...
    'Color',[0 0 0])
x_labels={'Data 1', 'Data 2'};
xticklabels(x_labels)
ylabel('Magnitude')
set(gca,'FontSize',20)
box off
annotation(figure1,'textbox',...
    [0.460714285714286 0.816857142857145 0.155357142857143 0.136904761904762],...
    'String',{'***'},...
    'FontSize',40,...
    'EdgeColor','none');

annotation(figure1,'line',[0.392857142857143 0.621428571428571],...
    [0.872809523809526 0.871428571428573],'LineWidth',2);



