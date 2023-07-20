function [spikeTime_pre, spikeTime_post, V] = poisson_pre_LIF(g_0, I_N_0, sigma_noise ,pre_fr ,duration, dt)
% generate post LIF response (spike train) given a fixed g_0

nBins = duration/dt;

% intrinsic parameters of the postsynaptic neuron / synapse
g_m = 25e-9; % S -> nS
c_m = 250e-12; % F -> pF
% E_syn = 0; % mV ; excitatory post syn reversal potential
% V_th = 20e-3; % V -> mV
% V_reset = 10e-3; % V -> mV
% V_spike = 50e-3; % V -> mV
% V_rest = 0;

E_syn = 0; % mV ; excitatory post syn reversal potential
V_th = -50e-3; % V -> mV
V_reset = -65e-3; % V -> mV
V_spike = 50e-3; % V -> mV
V_rest = -70e-3;

%% Generate presynaptic Poisson spike train
lambda = pre_fr/(1/dt); %parameter for the Poisson distribution, which is the mean as well as variance
spikeTrain_pre = poissrnd(lambda, 1, nBins);
clock = 1:nBins; %unit determined by dt
spikeTime_pre = clock(spikeTrain_pre>0);%t_k

%% Calculate monosynatpic conductance time course
delta_s = 1.5;%ms
tau_s = 3;%ms
g_syn = zeros(1,length(clock)+2);
single_g_timecourse = zeros(1,length(clock)+2);
for t =1:length(clock)
    single_g_timecourse(t) = -g_0*exp(-(t-delta_s)/tau_s);
end

for spike = 1:length(spikeTime_pre)
    g_syn(spikeTime_pre(spike):end)=g_syn(spikeTime_pre(spike):end)+single_g_timecourse(1:end-spikeTime_pre(spike)+1);
end

%% Gaussian noise generator
% Mean noise level (current) -> determine average rate
%I_N_0 and sigma_noise as predefined
X = normrnd(0,1,1,length(clock)+2);
I_N = I_N_0 + sigma_noise * sqrt(c_m * g_m) .* X;

%% Post LIF
spikeTrain_post = zeros(1,nBins+2);
V = zeros(1,nBins);V(1)=V_rest;
I_total = zeros(1,nBins+2);
i_syn = zeros(1,nBins+2);
I_total(1) = i_syn(1) + I_N(1);
t = 1;
while t<length(clock)
    dV = (-g_m / c_m * (V(t)-V_reset) + I_total(t) / c_m)*dt; 
    V(t+1) = V(t)+dV;
    if V(t) > V_th
        V(t+1) = V_spike;
        V(t+2) = V_reset;
        V(t+3) = V_reset;
        I_total(t+1) = i_syn(t+1) + I_N(t+1);
        I_total(t+2) = i_syn(t+2) + I_N(t+2);
        I_total(t+3) = i_syn(t+3) + I_N(t+3);
        spikeTrain_post(t+1)=1;
        t = t+2;
    end
    if t>=nBins
        break
    end
    i_syn(t+1) = g_syn(t) * (V(t)-E_syn);
    I_total(t+1) = i_syn(t+1) + I_N(t+1);
    t=t+1;
end

spikeTime_post = clock(spikeTrain_post>0);
spikeTime_post = spikeTime_post*dt;
spikeTime_pre = spikeTime_pre*dt;

end