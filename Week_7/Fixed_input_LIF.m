function [spikeTime, V_m] = Fixed_input_LIF(I, duration, dt)
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
nBins = floor(duration/dt);
clock = 1:nBins; %unit determined by dt

% intrinsic parameters of the postsynaptic neuron / synapse
g_m = 25e-9; % S -> nS
c_m = 250e-12; % F -> pF
V_th = -50e-3; % V -> mV
V_reset = -65e-3; % V -> mV
V_spike = 50e-3; % V -> mV
V_rest = -70e-3; % V -> mV

%% Check if input length matches
nBins_I = length(I);
if nBins_I ~= nBins
    nBins = nBins + 1;
    if nBins_I ~= nBins
        error('Simulation input length does not match. Try change duration or input length.')
    end
end

%% Simulate LIF using Euler's method
% Create space (a binary or zeros array of length nBins) for storing whether the neuron spiked in each time bin
spikeTrain = zeros(1,nBins);

% Create space (zeros of length nBins + 2) for storing membrane potential V_m.
V_m = zeros(1,nBins + 2);
% Set the value of the first time bin of V_m to be V_rest
V_m(1)=V_rest;

% Set up timer with the unit being the duration of the time bin
t = 1;

% Using a while loop to go through all time bins
while t<length(clock)
    % For each time t, calculate the change of V_m for the next time bin
    % t+1, using the LIF model and Euler's method
    dV_m = (-g_m / c_m * (V_m(t)-V_reset) + I(t) / c_m)*dt; 
    % Update V_m using Euler's method
    V_m(t+1) = V_m(t)+dV_m;
    % If membrane potential is higher than AP threshold, generate a spike!
    if V_m(t) > V_th
        % Set V_m at next time step to be V_spike
        V_m(t+1) = V_spike;
        % Set V_m at the following two time steps to be V_reset
        V_m(t+2) = V_reset;
        V_m(t+3) = V_reset;
        % Set spikeTrain at time t+1 to be in
        spikeTrain(t+1)=1;
        % Update timer to account for the duration for V_reset
        t = t+2;
    end
    % Use an if statement to make sure the current timer is not longer than
    % nBins
    if t>=nBins
        break
    end
    % Update timer to move to the next time bin to be updated
    t=t+1;
end

spikeTime = clock(spikeTrain>0);
spikeTime = spikeTime*dt;

end