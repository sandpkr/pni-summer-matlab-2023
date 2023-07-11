%% add our analysis path and check any missing dependencies

% start fresh and clear all workspace variables, open figures, and command history
clear all, close all, clc

% addpath recursively - i.e. with all subfolders in our initial head directory
addpath(genpath('C:\Users\sbolkan\Desktop\Week_6\Code'))
path % check what's in our path
% https://github.com/kwikteam/npy-matlab

% let's look at the code and toolboxes we'll need for this excercise
which week6_lecture1 % make sure our script or function is in our path
[fList,pList] = matlab.codetools.requiredFilesAndProducts('week6_lecture1.m');
% for other options search: how do i identify program dependencies in matlab
fList'
pList.Name


%% let's load our data and get aquainted with it

dataPath = 'C:\Users\sbolkan\Desktop\Week_6\Data';
cd(dataPath)


%% BRIEF ASIDE: We often have to switch between different languages and 
% data types in our analyses and matlab has many ways to handle this 
% Here we'll explore converting between some data types, opening different types of files in matlab,
% use the NPY-matlab repository to read python files into matlab 
% and then write back out to python. We'll also get a picture of what it's
% like to build out an analysis pipeline for single neuron spiking data

% look for a .meta file in my current directory and select it so as to
% conveniently get the file name and file path
[fileName,filePath] = uigetfile('*.meta'); 

% ReadMeta is a custom function to read this type of file - we will gloss
% over it's details - but we can use breakpoints in the function to learn how it
% operates 
myMetaFile          = ReadMeta(fileName, filePath);

% our myMetaFile var contains lots of relevant information about our data but
% one thing we want to grab from it for our purposes here is the precise 
% sampling rate that we used to aquire our data
fields(myMetaFile)
myMetaFile.imSampRate  % notice this is a string of characters representing a number

% we want to convert this 'string' to a number so we can do actual math
% with it
sampRate = str2double(myMetaFile.imSampRate) 

% now we'll use the readNPY function from the NPY-matlab repository to read a 
% python .npy array into a matlab matrix
% https://github.com/kwikteam/npy-matlab
spike_samples    = readNPY('spike_samples.npy');
spike_clusters   = readNPY('spike_clusters.npy');

% let's explore what our variables are
max(spike_samples)
unique(spike_clusters)
numel(unique(spike_clusters))
size(spike_samples)
size(spike_clusters)

% let's convert spike_samples into spike_seconds by simply dividing by
% our data sampling rate

% first we need to convert a uint64 variable - 64 bit unsigned integer
% into a numeric double -- try it w/ or w/o the conversion!
spike_samples2 = cast(spike_samples,'double');  % notice this overwrites the variable type
spike_seconds =  spike_samples2/sampRate; % divide samples by sampling rate to get units of seconds

% explore the converted variable
% what is a uint64 variable? what is a int32 variable? what is a double?
max(spike_seconds)
max(spike_seconds)/60  
spike_seconds(1:10)

% now save this new variable as a new .npy file
writeNPY(spike_seconds,'spike_seconds.npy');

% one final example of a matlab function to read a tab-delimted file (.tsv,
% .txt, etc) - there are many many in-built functions 
cluster_group  = tdfread('cluster_group.tsv');  

% explore this variable 
unique(spike_clusters)
numel(unique(spike_clusters))
fields(cluster_group)
cluster_group.cluster_id
numel(cluster_group.cluster_id)
cluster_group.group

% how many unique cluster IDs?
foo = cluster_group.group == 'good '
% find the index of the rows that all have 1?


%% now let's skip forward to the processed data
clearvars -except dataPath

load('data.mat')
[~, nNeuron]   = size(timeSqueezedFR)    % we have a cell array the length of our unique clusters from above
[nTrial, nBin] = size(timeSqueezedFR{1}) % each cell is size 258 x 67 - trials x time bins in our recording

figure; plot(timeSqueezedFR{5}','k-') % plotting all trials from cluster 5 here

% explore our behavior data
fields(behavEvents)            % we have lots of fields to index into

size(behavEvents.choice)       % all of these are the length nTrial matching our timeSqueezedFR
unique(behavEvents.choice)     % the unique values of choice field are 0 and 1 - correspond to left vs right choice
unique(behavEvents.trialType)
binID  
numel(binID)                   % binID is the length of nBin - our time bins within a trial
unique(binID)                  % 5 unnique values for binIDs
unique(binID_label)            % 5 unique descriptors for binID_label - correspond to our task bin 'epochs'
numel(binID)

% we'll focus on these and save them as new vars
choice    = behavEvents.choice;    % 0 means left and 1 means right choice
trialType = behavEvents.trialType; % 0 means reward was left 1 means reward was right
accuracy  = choice == trialType;   % when choice matches reward side - the animal was correct

%% getting acquainted further, let's plot some data in more detail, and also begin to 
% process it using the cellfun function

% let's keep our workspace simple and save only what we need for this script
clearvars -except timeSqueezedFR trialType choice accuracy...
           nNeuron nBin binID binID_label

nn = 3; % 3 5 7  let's change this to plot different neurons
% what do you notice about the firing rate scales, baselines, right/left
% differences?

% calculate mean firing rates on left/right choice trials
meanFR_L = mean(timeSqueezedFR{nn}(choice==0,:),1);  % get mean firing rate on left choice trials for neuron nn
meanFR_R = mean(timeSqueezedFR{nn}(choice==1,:),1);  % get mean firing rate on right choice trials for neuron nn

% now plot it 
figure;
plot(1:nBin, meanFR_L, 'b-'); hold on
plot(1:nBin, meanFR_R, 'r-')

% add aesthetics and labels and anything helpful to interpret
box off
xlabel('time bin')
ylabel('firing rate')
titlestr = ['neuron ' num2str(nn)];
title(titlestr);
ylimits = round(get(gca,'ylim'));
plot(ones(numel(ylimits(1):ylimits(2)),1) * find(binID==2,1),...
    ylimits(1):ylimits(2), 'k:')
plot(ones(numel(ylimits(1):ylimits(2)),1) * find(binID==3,1),...
    ylimits(1):ylimits(2), 'k:')
plot(ones(numel(ylimits(1):ylimits(2)),1) * find(binID==4,1),...
    ylimits(1):ylimits(2), 'k:')
plot(ones(numel(ylimits(1):ylimits(2)),1) * find(binID==5,1),...
    ylimits(1):ylimits(2), 'k:')

%% digging deeper, let's process the data a bit, learn how to use cellfun, and plot our results

% let's keep our workspace simple and save only what we need for this script
clc, close all
clearvars -except timeSqueezedFR trialType choice accuracy ...
           nNeuron nBin binID binID_label

% let's smooth our data first - cellfun function is fun!!
smoothFunc = @(x)smoothdata(x,2,'movmean',5);  % define a function that will act on a stand-in x variable
             % this will act on x, apply the smoothdata fxn, in the second
             % dimension of x (for us across time bins), using the moving
             % mean option over a 5 bin running window
smoothFR = cellfun(smoothFunc,timeSqueezedFR,'UniformOutput',false); 
            % now use cellfun to apply our predefined smoothFunc to all the
            % cells in timeSqueezedFR at the same time - we have to also
            % specify 'UniformOutput', false option - as we want a cell
            % array back

% check that we got everything right by visualizing the output 
% also we can simply copy paste our plotting code from above into a simple
% function - call it mySingleNeuronPlot - it's not very powerful but it's a
% start and will save some space in our script here
nn = 3;
figure
subplot(1,2,1);
mySingleNeuronPlot(timeSqueezedFR{nn}, choice, binID, nn); hold on; title('raw data')
subplot(1,2,2);
mySingleNeuronPlot(smoothFR{nn}, choice, binID, nn); title('smoothed data')
disp(['how smooth!'])

%% now let's use cell fun to zscore our smoothed data
% as an excercise we can also try rewriting to instead rescale (another common normalization)
clc, close all

zFunc = @(x)zscore(x,[],2); % define our function and how it will act on our stand-in x variable
z_smoothFR = cellfun(zFunc, smoothFR,'UniformOutput', false); % apply that function to all cells in smoothFR

nn = 3; % sanity to check what our function did to the same neuron
figure
subplot(1,3,1) 
mySingleNeuronPlot(timeSqueezedFR{nn}, choice, binID, nn); hold on; title('raw data')
subplot(1,3,2)
mySingleNeuronPlot(smoothFR{nn}, choice, binID, nn); title('smoothed data')
subplot(1,3,3)
mySingleNeuronPlot(z_smoothFR{nn}, choice, binID, nn); title('z-scored data')

disp(['how smooth and normalized!'])

%% one last thing! sometimes we only want to look at the deviations - what's
% changing from average - and we want the data to be centered around 0 - so
% for this would subtract average firing rate

clc, close all
meanFunc = @(x)mean(x,1); 
z_smoothFR_mean = cellfun(meanFunc, z_smoothFR,'UniformOutput', false);

subtractFunc = @(x,y) x-y;
z_smoothFR_ms = cellfun(subtractFunc,z_smoothFR,z_smoothFR_mean,'UniformOutput', false);

nn = 3; % sanity to check what our function did to the same neuron
figure
subplot(1,4,1) 
mySingleNeuronPlot(timeSqueezedFR{nn}, choice, binID, nn); hold on; title('raw data')
subplot(1,4,2)
mySingleNeuronPlot(smoothFR{nn}, choice, binID, nn); title('smoothed data')
subplot(1,4,3)
mySingleNeuronPlot(z_smoothFR{nn}, choice, binID, nn); title('z-scored data')
subplot(1,4,4)
mySingleNeuronPlot(z_smoothFR_ms{nn}, choice, binID, nn); title('mean-subtracted data')

disp(['how smooth and normalized and centered!'])

%% let's try one final summary of our processed data for today
neuronData = z_smoothFR_ms;  % let's give this a simpler name first
clc, close all              % and clear our workspace down to the essentials again
clearvars -except neuronData trialType choice accuracy ...
           nNeuron nBin binID binID_label

find(binID == 5)   % this is one way to get an index of all the bins of a task epoch - 
                   % - but we'd have to remember what our numbers correspond to!      
idx = find(strcmp(binID_label,'outcome'))  % this gives the same result - and is more interpretable
                   % we'll save the values as idx to index into these only
meanFunc = @(x)mean(x(:,idx),2);   % we'll take the mean of our indexed values in all cells of the cell array
epochFR = cellfun(meanFunc, neuronData,'UniformOutput',false); % 

epochFR_mat = cell2mat(epochFR); % convert a cell to a matrix - works because our cells are all the same size!
                                 % this allows easier slicing of the data



