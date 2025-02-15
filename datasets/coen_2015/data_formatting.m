% ----------------------------------------------------------------------------------------
% Adpated code from the original authors to parse and load data. The outputs will be
% shared with team members for benchmarking.

% Parsing of features that irrelevant to our project are removed (eg. spatial frequency 
% and RF etc.). Only data pertaining to orientation tunings (ordered) are saved to
% separate mat files for future use. 

% Refer to main_LoadAndParse.m for full code.
% ----------------------------------------------------------------------------------------


%% load one example dataset
clear all
sess = '06';
load(sprintf('%s.mat',sess));


%% parse responses to different image sets

%*** pre-processing: shift by 50ms to account for response latency
latency=50;
tmp = resp_train;
tmp(:,:,:,1:end-latency) = resp_train(:,:,:,latency+1:end);
tmp(:,:,:,end-latency+1:end) = resp_train_blk(:,:,:,1:latency);
resp_train = tmp;

%*** compute spike count per stimulus presentation
resp = nansum(resp_train,4); % [#neurons #stimuli #repeats]
reps = 20; %number of repeats

%*** create separate variables to store responses to different image subsets
clear resp_nat  resp_sf  resp_ori resp_as
tmp = squeeze(resp(:,1:(2*9*30),:));
tmp = reshape(tmp,size(tmp,1),2,9,30,reps);
resp_nat(:,1,:,:,:) = tmp(:,1,:,:,:); % small natural images
resp_nat(:,2,:,:,:) = tmp(:,2,:,:,:); % large natural images
% Note: there are 9 categories x 30 instances
% the categories include (in this order):
% - strong orientation content, mainly 0, 45, 90 or 135 degrees
% - weak orientation content, mainly 0, 45, 90 or 135 degrees
% - no dominant orientation

tmp = squeeze(resp(:,[1:128]+(2*9*30),:)); % gratings for spatial frequency tuning
resp_sf = reshape(tmp,size(tmp,1),4,4,8,reps); % [#neurons #phases #orientations #s.f. #repeats]

tmp = squeeze(resp(:,[1:64]+(128+2*9*30),:)); % gratings for orientation tuning
resp_ori = reshape(tmp,size(tmp,1),4,16,reps); % [#neurons #phases #orientations #repeats]

tmp = squeeze(resp(:,[1:224]+(64+128+2*9*30),:)); % gratings for size tuning
resp_as = reshape(tmp,size(tmp,1),4,2,7,4,reps); % [#neurons #phases #categories #sizes #orientations #repeats]
% Note: 2 categories, 1=circular patch (donut hole), 2=annular patch (donut).



%% Get orientation tuning for neurons in this session, separated by phases, save to spike_cnt

[nNeuron,nPhase,nOri,nTrial] = size(resp_ori);

% To unify representation across datasets, the orientations will be shifted to be [0,pi]
% in radians. So we have forced the stimulus labels to rotate counter-clockwise by one
% quadrant. Shouldn't affect decoding performance, but note here.
orientations = [90:-11.25:-78.75]; % hard coded by the authors, the orientations shown
orientations = (orientations + 90)/360*2*pi;

% Save spike counts, separated in fields by phase
spike_cnt = struct();

for phase=1:nPhase
    out = zeros(nNeuron,nTrial,nOri);
    for neuron = 1:nNeuron
        for trial = 1:nTrial
            out(neuron,trial,:) = resp_ori(neuron,phase,:,trial);
        end
    end
    spike_cnt.(sprintf('phase%d',phase)) = out;
end

% Pick an example neuron and look at how different its orientation tuning is across trials
f = figure();
f.Position(3:4) = [1400 700];
rand_neuron = randi(nNeuron,1);
rand_phase = 1;
for i=1:nTrial
    subplot(5,5,i);
    plot(orientations,squeeze(spike_cnt.(sprintf('phase%d',rand_phase))(rand_neuron,i,:)),'-.');
    title(sprintf('Trial #%d',i));
    xlabel('Orientation');
    ylabel('Mean spike count');   
    yLim = get(gca,'YLim');
    set(gca,'YLim', [0 yLim(2)]);
end
yLim = get(gca,'YLim');
set(gca,'YLim', [0 yLim(2)]);
subplot(5,5,[21:25]);
plot(orientations,squeeze(nanmean(spike_cnt.(sprintf('phase%d',rand_phase))(rand_neuron,:,:))),'-.');
title('Averaged across trials');
sgtitle(sprintf('Example Neuron #%d',rand_neuron));


% Output format: struct -> four phases -> nNeuron x nTrial x nOri
save(sprintf('Data Formatted/Coen_%s',sess),'spike_cnt','orientations');



% ----------------------------------------------------------------------------------------
% Some questions have already been resolved, answers posted here.
% Q1: Do the firing rates by grating orientation match their inferred preferred
% orientation from the steerable pyramid model derived from naturalistic images?
%     -> No, you can't link them on a one-to-one basis. There are 4 preferred orientations 
%        in the naturalistic image trials but 16 in the gratings trials, so the two are
%        different and can't be compared directly. (See paper)
% Q2: Do the phases matter?
%     -> Yes, these are spatial phases of the gratings presented and neurons have
%        different firing rates by orientation maps. Don't pool across phases.
% Q3: How different are the spike rates across trials / repeats? 
%     -> At a first glance, they are not as similar, since majority of single trials have
%     very low firing rate such that the values are more discretized. Averaging should
%     therefore smooth the orientation tuning cuurves and boost decoding power. A more
%     quantitative analysis can be run to ensure that the rates across repeats are indeed 
%     convergent.
% ----------------------------------------------------------------------------------------


