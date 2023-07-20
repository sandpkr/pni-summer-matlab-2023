% Matlab function components:
function [spikeTime, V_m] = Fixed_input_LIF_practice(I, duration, dt)
% Documentation
% generate post LIF response (spike train) given a fixed current input
% Input:  variable_name          explanation           
%         I                      Steady current input level (A)
%         duration               Duration of simulation (s)
%         dt                     Time bin size of stimulation (s)

% Output: variable_name          explanation           
%         spikeTime              spike timing of the LIF neuron (s)
%         V                      voltage trace of the LIF neuron (V)
%% Setting up the simulation
% First, set up time (number of bins)
nBins = ;
% sequential time points starting unit determined by dt
clock = ; 

% Check if input length matches
nBins_I = length(I);
if nBins_I ~= nBins
    
end

% intrinsic parameters of the postsynaptic neuron / synapse
















g_m = 25e-9; % S -> nS
c_m = 250e-12; % F -> pF
V_th = -50e-3; % V -> mV
V_reset = -65e-3; % V -> mV
V_spike = 50e-3; % V -> mV
V_rest = -70e-3; % V -> mV

%% Simulate LIF using Euler's method
% Create space (a binary or zeros array of length nBins) for storing whether the neuron spiked in each time bin
spikeTrain = 

% Create space (zeros of length nBins + 2) for storing membrane potential V_m.
V_m = 
% Set the value of the first time bin of V_m to be V_rest
V_m(1)=

% Set up timer with the unit being the duration of the time bin


% Using a while loop to go through all time bins
while t<length(clock)
    % For each time t, calculate the change of V_m for the next time bin
    % t+1, using the LIF model and Euler's method

    
    
    
    % Update V_m using Euler's method

    
    
    
    
    % If membrane potential is higher than AP threshold, generate a spike!
    if V_m(t) > V_th
        % Set V_m at next time step to be V_spike
        

        % Set V_m at the following two time steps to be V_reset
        

        % Set spikeTrain at time t+1 to be in
        


        % Update timer to account for the duration for V_reset


    end
    % Use an if statement to make sure the current timer is not longer than
    % nBins
    if t>=nBins
        break
    end
    % Update timer to move to the next time bin to be updated


end

% Store spike time

end