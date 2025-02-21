% ----------------------------------------------------------------------------------------
% Adpated code from the original authors to parse and load data. The outputs will be
% shared with team members for benchmarking.

% The script contains two parts from the original authors:
%   1. Convert spike times to 1ms bins.
%   2. Remove bad/very low firing units.

% Because of the way the authors structured their code there will be intermediary
% variables S saved to output that we won't use. 

% Refer to script_mean_firing_rates_gratings.m for full code. 
% ----------------------------------------------------------------------------------------


%% Set parameters
SNR_threshold = 1.5;
firing_rate_threshold = 1.0;  % 1.0 spikes/sec
binWidth = 20;  % 20 ms bin width

    
%% Specify parameters relevant to experiment

length_of_gratings = 1;  % each gratings was shown for 1.28s, take the last 1s

addpath('./data_and_scripts/');
filenames{1} = './data_and_scripts/spikes_gratings/data_monkey1_gratings.mat';
filenames{2} = './data_and_scripts/spikes_gratings/data_monkey2_gratings.mat';
filenames{3} = './data_and_scripts/spikes_gratings/data_monkey3_gratings.mat';

monkeys = {'monkey1', 'monkey2', 'monkey3'};
    

%% Bin spike times into 1ms bins

for imonkey = 1:length(monkeys)
    S = [];

    fprintf('binning spikes for %s\n', monkeys{imonkey});

    load(filenames{imonkey});

    num_neurons = size(data.EVENTS,1);
    num_gratings = size(data.EVENTS,2);
    num_trials = size(data.EVENTS,3);

    edges = 0.28:0.001:1.28;  % take 1ms bins from 0.28s to 1.28s

    for igrat = 1:num_gratings
        for itrial = 1:num_trials
            for ineuron = 1:num_neurons
                S(igrat).trial(itrial).spikes(ineuron,:) = histc(data.EVENTS{ineuron, igrat, itrial}, edges);
            end
            S(igrat).trial(itrial).spikes = S(igrat).trial(itrial).spikes(:,1:end-1);  % remove extraneous bin at the end
        end
    end

    save(sprintf('./data_and_scripts/spikes_gratings/S_%s.mat', monkeys{imonkey}), 'S', '-v7.3');
end
    

%%  Pre-processing: Remove bad/very low firing units

% remove units based on low SNR

for imonkey = 1:length(monkeys)
    load(filenames{imonkey});
        % returns data.SNR
    keepNeurons = data.SNR >= SNR_threshold;
    clear data;

    fprintf('keeping units with SNRs >= %f for %s\n', SNR_threshold, monkeys{imonkey});

    load(sprintf('./data_and_scripts/spikes_gratings/S_%s.mat', monkeys{imonkey}));
        % returns S(igrat).trial(itrial).spikes

    num_grats = length(S);
    num_trials = length(S(1).trial);

    for igrat = 1:num_grats
        for itrial = 1:num_trials
            S(igrat).trial(itrial).spikes = S(igrat).trial(itrial).spikes(keepNeurons,:);
        end
    end

    save(sprintf('./data_and_scripts/spikes_gratings/S_%s.mat', monkeys{imonkey}), 'S', '-v7.3');
end

% remove units with mean firing rates < 1.0 spikes/sec

for imonkey = 1:length(monkeys)
    load(sprintf('./data_and_scripts/spikes_gratings/S_%s.mat', monkeys{imonkey}));
        % returns S(igrat).trial(itrial).spikes
    num_grats = length(S);
    num_trials = length(S(1).trial);

    mean_FRs = [];   

    for igrat = 1:num_grats
        for itrial = 1:num_trials
            mean_FRs = [mean_FRs sum(S(igrat).trial(itrial).spikes,2)/1.0];
        end
    end

    mean_FRs_gratings = mean(mean_FRs,2);
    keepNeurons = mean_FRs_gratings >= firing_rate_threshold;

    for igrat = 1:num_grats
        for itrial = 1:num_trials
            S(igrat).trial(itrial).spikes = S(igrat).trial(itrial).spikes(keepNeurons,:);
        end
    end

    save(sprintf('./data_and_scripts/spikes_gratings/S_%s.mat', monkeys{imonkey}), 'S', '-v7.3');

end


%%  Calculate spike counts according to specified bin size
for imonkey = 1:length(monkeys)

    fprintf('spike counts in %dms bins for %s\n', binWidth, monkeys{imonkey});

    load(sprintf('./data_and_scripts/spikes_gratings/S_%s.mat', monkeys{imonkey}));
        % returns S(igrat).trial(itrial).spikes
    num_grats = length(S);
    num_trials = length(S(1).trial);

    for igrat = 1:num_grats
        for itrial = 1:num_trials
            S(igrat).trial(itrial).counts = bin_spikes(S(igrat).trial(itrial).spikes, binWidth);
        end
    end

    save(sprintf('./data_and_scripts/spikes_gratings/S_%s.mat', monkeys{imonkey}), 'S', '-v7.3');
end
    
    
%%  Compute trial-averaged population activity (PSTHs)

for imonkey = 1:length(monkeys)
    fprintf('computing PSTHs for %s\n', monkeys{imonkey});

    load(sprintf('./data_and_scripts/spikes_gratings/S_%s.mat', monkeys{imonkey}));
        % returns S(igrat).trial(itrial).spikes
    num_grats = length(S);
    num_trials = length(S(1).trial);

    for igrat = 1:num_grats
        mean_FRs = zeros(size(S(igrat).trial(1).counts));
        for itrial = 1:num_trials
            mean_FRs = mean_FRs + S(igrat).trial(itrial).counts;
        end
        S(igrat).mean_FRs = mean_FRs / num_trials;
    end

    save(sprintf('./data_and_scripts/spikes_gratings/S_%s.mat', monkeys{imonkey}), 'S', '-v7.3');
end
    

%% Visualize the firing rate (per second) for select example neurons on select trials
imonkey = 1;
load(sprintf('./data_and_scripts/spikes_gratings/S_%s.mat', monkeys{imonkey}));
num_grats = length(S);
num_trials = length(S(1).trial);

f = figure();
f.Position = [0 0 1500 900];
counter = 1;
for ineuron = 1:10
    for itrial = 1:8
        subplot(8,10,counter);
        avg_FR = zeros(num_grats,1);
        for igrat = 1:num_grats
            avg_FR(igrat) = mean(S(igrat).trial(itrial).counts(ineuron,:));
        end
        plot(1:num_grats,avg_FR);
        counter = counter + 1;
    end
end


%% Visualize the firing rate (per second) for select example neurons averaged across trials
%  split into two folds
f = figure();
f.Position = [0 0 1500 200];
counter = 1;
for ineuron = 1:10
    for split = 1:2
        trials = [1:100] + 100*(split-1);
        subplot(2,10,counter);
        avg_FR = zeros(num_grats,1);
        for igrat = 1:num_grats
            for itrial = trials
                avg_FR(igrat) = avg_FR(igrat) + ...
                    mean(S(igrat).trial(itrial).counts(ineuron,:));
            end
            avg_FR(igrat) = avg_FR(igrat)/length(trials);
        end
        plot(1:num_grats,avg_FR);
        counter = counter + 1;
    end
end


%% Visualize an example mean neuron's firing rate averaged across trials by the time bins 
%  within the 1 second stimulus onset window
figure();
ineuron = 1;
igrat = 3;
plot(1:50,S(igrat).mean_FRs(ineuron,:));


%% Run if youu want to see what the stimulus looks like (moving gradients not static)
load('./data_and_scripts/stimuli_gratings/M_grating090.mat');
num_images = size(M,3);
f = figure;
for iimage = 1:num_images
	imagesc(M(:,:,iimage));
	colormap(gray);
	pause(0.04);
end


%% Format the data for our downstream analysis 

orientations = [0:30:330]; % hard coded by the authors
for imonkey = 1:length(monkeys)
    fprintf('Formatting data into our template for %s\n', monkeys{imonkey});
    load(sprintf('./data_and_scripts/spikes_gratings/S_%s.mat', monkeys{imonkey}));
    num_grats = length(S);
    num_trials = length(S(1).trial);
    num_neurons = size(S(1).mean_FRs,1);
    spike_cnt = zeros(num_neurons,num_trials,num_grats);

    % Loop through every neuron and orientation to count number of spikes within that one
    % second post-stimulus onset window
    counter = 1;
    for ineuron = 1:num_neurons
        for itrial = 1:num_trials
            for igrat = 1:num_grats
                spike_cnt(ineuron,itrial,igrat) = mean(S(igrat).trial(itrial).counts(ineuron,:));
            end
            counter = counter + 1;
        end
    end

    % Output format: 
    %   spike_cnt -> nNeuron x nTrial x nOri
    %   orientations -> 1 x nOri
    save(sprintf('./Data Formatted/Smith_0%d',imonkey),'spike_cnt','orientations');
end

