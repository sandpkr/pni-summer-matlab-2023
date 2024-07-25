clear
clc
close all

load('velocity_array.mat') %load velocity data
load('stimulus_array.mat') %load stimulus data

for i=1:size(stimulus_array,1)
    test_array=velocity_array(i,:);
    plot(test_array) % where ever you see a peak, stimulus was delivered at that instant
    title(num2str(i)) % adding the title, so we know which iteration it is
    waitforbuttonpress % for convinience. this will execute loop only when we press a button
    close all % deleting the plot, so that we do not have so many figures 
end

%% determining when the stimulus was delivered

locs_array=[];  % define an empty array
for i=1:size(stimulus_array,1)
    test_array=stimulus_array(i,:);
    [pks,locs] = findpeaks(test_array);
    locs_array(i,:)=locs;
end

%% find the velocity at stimulus onset
velocity_at_stim_onset_array=[];  % define an empty array
for i=1:size(velocity_array,1)
    test_array=velocity_array(i,:);
    velocity_at_stim_onset_array(i,:)=test_array(locs_array(i));
end

%% plot histogram of velocity at stim onset
histogram(velocity_at_stim_onset_array)