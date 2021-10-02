% compute mean phase coherence for n cell network

n = num_e;
spiketimes = spiketimes_e2;
% construct array with all cell pairs
for i = 1:n
%i=4;
    temp1 = i*ones(n-1,1);
    temp2 = (1:n)'; 
    temp2 = temp2(temp2~=i);
    temp = [temp1, temp2];
    if i == 1
        cell_pairs = temp;
    else
        cell_pairs = [cell_pairs; temp];
    end
end
    

mpc_cellpairs = zeros(length(cell_pairs),1);

for j=1:length(cell_pairs)

    % define cell a and cell b
    ca_spiketimes = spiketimes(spiketimes(:,2)==cell_pairs(j,1),1);
    cb_spiketimes = spiketimes(spiketimes(:,2)==cell_pairs(j,2),1);
    
    if ~isempty(ca_spiketimes) && ~isempty(cb_spiketimes)
    
    % determine index of first cell b spike within a cell a cycle
    first_cb_spike = find(cb_spiketimes>ca_spiketimes(1),1,'first');
    % determine index of last cell b spike within a cell a cycle
    last_cb_spike = find(cb_spiketimes<ca_spiketimes(end),1,'last');

    num_spikes = last_cb_spike-first_cb_spike+1;
    phase = zeros(num_spikes,1);
    cos_phase = zeros(num_spikes,1);
    sin_phase = zeros(num_spikes,1);

    % compute mean phase of cell b spikes relative to cell a cycle
    k=1;
    for i=first_cb_spike:last_cb_spike
        % for each cell b spike determine cell a cycle containing the spike
        ind_ca_spike2 = find(ca_spiketimes>=cb_spiketimes(i),1,'first');
        ca_spike2 = ca_spiketimes(ind_ca_spike2);
        ca_spike1 = ca_spiketimes(ind_ca_spike2-1);

        phase(k) = 2*pi*(cb_spiketimes(i)-ca_spike1)/(ca_spike2-ca_spike1);
        cos_phase(k) = cos(phase(k));
        sin_phase(k) = sin(phase(k));
        k=k+1;
    end

    mean_cos = mean(cos_phase);
    mean_sin = mean(sin_phase);
    mpc_cellpairs(j) = sqrt(mean_cos^2 + mean_sin^2);
    
    end

end

% remove zero and NaN entries
mpc_cellpairs = mpc_cellpairs(mpc_cellpairs~=0);
mpc_cellpairs(isnan(mpc_cellpairs))=[];

mean_mpc = mean(mpc_cellpairs)