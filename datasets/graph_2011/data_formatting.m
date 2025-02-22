% ----------------------------------------------------------------------------------------
% Adapted part of the script from examineGrafData.m, formatted the data into our template
% for downstream analysis. I recommend going back to the author's code and refer to how
% they constructed the tuning functions, since I cut out all those parts in this script.

% Can choose to average across [0,pi] and [pi,2pi], but I didn't opt in here, because I
% wasn't sure if it's fair to claim that the spike trajectories are cyclic around pi.
% ----------------------------------------------------------------------------------------


%% Load the data
for arrayNumber = 1:5
    load(sprintf('./array files/array_%d.mat', arrayNumber));
    nNeur = n_neur;
    nRpts = n_trial;
    nOris = n_ori;
    ori = ori;
    oriAxis = ori_tot;
    stsAll = spk_times;


    %% Compute spike counts for each trial, orientation and neuron
    scAll = zeros(nNeur,nRpts,nOris);
    for jori = 1:nOris
        idx = find(ori == oriAxis(jori));
        scAll(:,:,jori) = cellfun(@length, stsAll(:,idx));
    end
    scAll = permute(scAll,[3,1,2]);  % permute to be [ori,neuron,rpt] 

    % If true, average [0 180] with responses from [180 360]
    REFLECT = false;  
    if REFLECT
        % average over direction
        scRef = zeros(nOris/2,nNeur,nRpts*2);
        scRef(:,:,1:nRpts) = scAll(1:nOris/2,:,:);
        scRef(:,:,nRpts+1:2*nRpts) = scAll(nOris/2+1:end,:,:);
        nOris = nOris/2;
        nRpts = nRpts*2;
        scAll = scRef;
        oriAxis = oriAxis(1:nOris);
    end

    % Reshape to unify formatting with other datasets
    scAll = permute(scAll,[2,3,1]);


    %% Visualize tuning profiles across different trials of example neurons
    f = figure();
    f.Position = [0 0 1500 900];
    counter = 1
    for i=1:10
        for j=1:5
            subplot(5,10,counter);
            plot(oriAxis,squeeze(scAll(i,j,:)));
            counter = counter + 1;
        end
    end


    %% Visualize mean tuning profiles of example neurons averaged across trial folds
    f = figure();
    f.Position = [0 0 1500 300];
    counter = 1
    for i=1:10
        for split=1:2
            trials = [1:25] + 25*(split-1);
            subplot(2,10,counter);
            plot(oriAxis,squeeze(mean(scAll(i,trials,:),2)));
            counter = counter + 1;
        end
    end


    %% Save to output

    % Output format: 
    %   spike_cnt -> nNeuron x nTrial x nOri
    %   orientations -> 1 x nOri
    orientations = oriAxis/360*2*pi;
    spike_cnt = scAll;
    save(sprintf('./Data Formatted/Graph_0%d',arrayNumber),'spike_cnt','orientations');
end

