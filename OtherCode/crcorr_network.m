function [mean_crcorr, crcorr_cellpairs] = crcorr_network(n,vtraces)

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
    
crcorr_cellpairs = zeros(length(cell_pairs),1);

for j=1:length(cell_pairs)
    crcorr_cellpairs(j) = xcorr(vtraces(cell_pairs(j,1),:),vtraces(cell_pairs(j,2),:),0,'coeff');
end

crcorr_cellpairs_real = crcorr_cellpairs(~isnan(crcorr_cellpairs));

mean_crcorr = mean(crcorr_cellpairs_real);

end