%% Tutorial on decoding - specifically using neural data from a population
% of simultaneously recorded neurons to predict the binary decision of an animal
% Takeaways: 
% (1) Using matlab's statistical packages is 90% wrangling your data into
% the proper format - knowing how to navigate it, rearrange it and
% visualize it is key
% (2) After this, leveraging the statistical packages properly requires our
% own knowledge/expertise on the method, input from papers/internet/experts
% and reading the extensive matlab help documentation for a given fxn

% we'll learn the basics of matlab functions - fitcsvm and fitglm

%% first add our analysis path and check any missing dependencies

% start fresh and clear all workspace variables, open figures, and command history
clear all, close all, clc

% addpath recursively - i.e. with all subfolders under our defined head directory
addpath(genpath('C:\Users\sbolkan\Desktop\Week_6\Code'))

% check what's in our path and make sure the above (and all it's subfolders) is at the top


% let's look at the code and toolboxes we'll need for this excercise
which week6_lecture2 % make sure our script or function is in our path
[fList,pList] = matlab.codetools.requiredFilesAndProducts('week6_lecture2.m');
% for other options search: how do i identify program dependencies in matlab
fList'
pList.Name


%% let's load our neuron data and first get aquainted with it

clear all, close all, clc
dataPath = 'C:\Users\sbolkan\Desktop\Week_6\Data';
cd(dataPath)
load('data.mat','neuronData','behavEvents','binID','binID_label') % we'll load just a few variables inside data.mat
% we'll use neuronData - our processed form of timeSqueezedFR from 
% week6_lecture1 - go back to see how we used cellfun to get from timeSqueezedFR to neuronData

size(neuronData)    % we have a cell array of length Neurons 
% let's save that number into our workspace for use later - call it nNeurons

size(neuronData{1}) % the first cell is size 258 x 67 - trials x time bins in our recording
% let's save those numbers into our workspace for use later - call them nTrials and nBins

% plot all trials from Neuron 5 here - intializing a figure is a start
figure; 

% plot Neuron 5 trial 105 here - intializing a figure is a start
figure; 

% we'll focus on these variables from behavEvents and save them as
% something new so we don't have to . index into the behavEvents struct
choice    = behavEvents.choice;    % 0 means the animal made a leftward decision, and 1 means rightward
trialType = behavEvents.trialType; % 0 means reward was on the left, and 1 means reward was on the right

% print the length of choice and trialtype here:


% use choice and trialType to make a new variable called accuracy:


% plot all left choice trials from neuron 5 as blue lines and all
% right choice trials as red lines
figure; 

% now plot only the means - you could tap into our plot fxn from last week - mySingleNeuronPlot(neuronData, idx, binID , nn) 
figure;


%% Now that we have some idea of what we're working with let's reorganize our data
% to use matlabs fitcsvm and fitglm functions
% Goal: Use activity of all our neurons at different timebins in a trial to predict 
% whether animal will make a left or right decision

help fitcsvm 
% there are a lot of additional parameters we can pass!
% but the simplest form is: 
% MODEL=fitcsvm(X,Y) is an alternative syntax that accepts X as an
%     N-by-P matrix of predictors with one row per observation and one column
%     per predictor. Y is the response and is an array of N class labels. 

% we need X - our predictor matrix (for us: neural activity)
% and Y - a predictor (for us: the left/right choice made)

% Y predictor is easy - can you make it our choice matrix below?
Y = [];
% can you also turn all the 0s into -1s? this is a common re-scaling that
% will make it easier to interpret our model weights - it 0 centers
% (nearly) our data - see bonus note on weighting inputs at end here


% for X - we'll want to use neural activity sliced at each timebin of a
% trial (this is a mouse progressing down a T-maze towards making a
% left/right choice)
neuronData_mat = cat(3,neuronData{:}); 
size(neuronData_mat) % what did we just make here? 

% can you grab the activity on all trials in timeBin 1 of all neurons? -
% call it X - note you'll need to use the squeeze fxn
X = []; 

% great! now we have and X and Y - but we want to decode choice in a
% cross-validated manner - can our model predict trials it hasn't seen?
% for simplicity here - just split our X and Y into halves
X_in  = []; X_in  = X(1:2:end,:);
X_out = []; X_out = X(2:2:end,:); 
Y_in  = [];
Y_out = [];

% we're good to go for a very basic model!
ourModel = fitcsvm(X_in,Y_in,'KernelFunction','linear'); % 'BoxConstraint',1 
% note there are lots of parameters we may want to pass in but we'll gloss
% over for this now - it all depends on your data and goals

% use ourModel to make a prediction about what an animal's choice should be based
% on the neural activity we held out - X_out
out_Predicted = predict(ourModel,X_out);
sum(out_Predicted==Y_out')/numel(Y_out)  % now compare that prediction to the actual choice made on held out data

% this is a bit of a black box - let's go back to the data to see what the
% model utilized - and also scratch the surface of what ourModel contains
% the Beta or weights are good place to start
size(ourModel.Beta)  % the betas are size nNeurons

% find the index of the largest beta value using max
find(ourModel.Beta == max(ourModel.Beta))

% now plot that neurons mean firing rate on left/right choice trials as we did above


% now find the index of the smallest beta value using min
% and plot that neurons mean firing rate on left/right choice trials


%% Ultimately we want to repeat our decoding approach at each time bin of a trial 
% if we have time we'll do that here and plot the decoding accuracy across
% timebins



%% BONUS NOTES or different directions
% NOTE that matlab also has many in built functions and methods for X-Val
% cvpartition crossval etc
clearvars ourModel
ourModel    = fitcsvm(X,Y,'KernelFunction','linear'); % 'crossval','on' is also an argument we can pass in
CV_ourModel = crossval(ourModel);
1 - kfoldLoss(CV_ourModel)    

%%
% fitcsvm is one of a suite of decoding approaches we could use
clearvars ourModel
ourModel    = fitglm(X_in,Y_in,'linear','Distribution','binomial'); 
% 'Weights',Weights - we often want to weight our inputs
out_Predicted = predict(ourModel,X_out);  % note that this model outputs a prediction likliehood range 1 to 0
out_Predicted(out_Predicted<0.5) = 0;
out_Predicted(out_Predicted>0.5) = 1;
sum(out_Predicted==Y_out')/numel(Y_out) 

%%
% we often want to weight our model based on imbalances in the observations
% we have - fitglm has a convenient argument to pass in for this 
Zeros0 = find(Y_in == -1);
Ones1 = find(Y_in == 1);
Weights = zeros(length(Y_in),1);     
Weights(Zeros0) = 1/length(Zeros0);
Weights(Ones1) = 1/length(Ones1);
Weights = Weights / max(Weights);

ourModel    = fitglm(X_in,Y_in,'linear','Distribution','binomial', 'Weights',Weights); % here we pass in the Weights we defined above
out_Predicted = predict(ourModel,X_out);  % note that this model outputs a prediction likliehood range 1 to 0
out_Predicted(out_Predicted<0.5) = 0;
out_Predicted(out_Predicted>0.5) = 1;
sum(out_Predicted==Y_out')/numel(Y_out) 







