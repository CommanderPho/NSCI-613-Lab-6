function [timevec,traces,traces_all,crcorr_cellpairs]=SynchronyMeasures(n,spiketimes)
% compute network synchrony measures

% construct spiketime traces with spkgauss.m
[timevec,traces, traces_all] = spiketraces(n,spiketimes);
%[timevec,traces, traces_all] = spiketraces(num,spiketimes_e2);

% compute Golomb bursting measure
sigma = zeros(n,1);
for i=1:n
    sigma(i) = var(traces(i,:));
end
sigma_all = var(traces_all);
B = sigma_all/mean(sigma)

% compute pairwise cross correlations with zero time lag
[mean_crcorr, crcorr_cellpairs] = crcorr_network(n,traces);
mean_crcorr
end