function [timevec, traces, traces_all, GolombBursting, crcorr] = PINGSynchronyMeasures(num_e,spiketimes_e2)
% compute network synchrony measures

% construct spiketime traces with spkgauss.m
[timevec, traces, traces_all] = spiketraces(num_e, spiketimes_e2, false);
%[timevec,traces, traces_all] = spiketraces(num,spiketimes_e2);

% compute Golomb bursting measure
GolombBursting.sigma = zeros(num_e,1);
for i=1:num_e
    GolombBursting.sigma(i) = var(traces(i,:));
end
sigma_all = var(traces_all);
GolombBursting.B = sigma_all/mean(GolombBursting.sigma);

% compute pairwise cross correlations with zero time lag
[crcorr.mean, crcorr.cellpairs] = crcorr_network(num_e, traces);
end