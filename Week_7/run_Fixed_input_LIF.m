%% Run some simulations of the LIF with different input I
% Set up simulation time
duration  = 1;
dt  = 0.001;
nBins = duration /dt;

%% Case 1.1: Steady current injection
I_0 = 1e-9;%3.75e-10;
I = I_0* ones(1,nBins);
[spikeTime, V_m] = Fixed_input_LIF(I, duration, dt);

% Plot
figure
plot(V_m)
xlim([0,100])
xlabel('Time (ms)')
ylabel('V_m (V)')

%% Case 1.2: Steady current injection
I_0 = 3.76e-10;
I = I_0* ones(1,nBins);
[spikeTime, V_m] = Fixed_input_LIF(I, duration, dt);

% Plot
figure
plot(V_m)
xlim([0,1000])
xlabel('Time (ms)')
ylabel('V_m (V)')

%% Case 1.3: Steady current injection
I_0 = 3.78e-10;
I = I_0* ones(1,nBins);
[spikeTime, V_m] = Fixed_input_LIF(I, duration, dt);

% Plot
figure
plot(V_m)
xlim([0,1000])
xlabel('Time (ms)')
ylabel('V_m (V)')

%% Case 2: trying different current levels all at once!
nI0 = 5;
I_0_list = [linspace(3.65,3.8, nI0)].*1e-10;
figure 
hold on
for i = 1:length(I_0_list)
    subplot(nI0, 1, i)
    I = I_0_list(i)* ones(1,nBins);
    [spikeTime, V_m] = Fixed_input_LIF(I, duration, dt);
    
    % Plot
    plot(V_m)
    xlim([0,1000])
    
    ylabel('V_m (V)')
    legend(['I = ', sprintf('%.2f',I_0_list(i)*1e10),'x10^{-10}'])
end
xlabel('Time (ms)')

%% Case 3: quantification of number of LIF firing rate as a function of current input level
% Use a longer simulation duration
duration = 10; %s
nBins = duration /dt;
nI0 = 100;
I_0_list = [linspace(3.65,3.8, nI0)].*1e-10; % A

% Create space (an array of zeros) for storing the number of spikes during the simulation 
firing_rate_list = zeros(1,nI0);
for i = 1:length(I_0_list)
    subplot(nI0, 1, i)
    I = I_0_list(i)* ones(1,nBins);
    [spikeTime, V_m] = Fixed_input_LIF(I, duration, dt);
    nSpike = length(spikeTime);
    firing_rate_list(i) = nSpike / duration;
end
figure
plot(I_0_list, firing_rate_list, 'LineWidth',1)
xlabel('Current input (A)')
ylabel('Firing rate (Hz)')
