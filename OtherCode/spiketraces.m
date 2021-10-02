function [timevec,traces,traces_all] = spiketraces(n,spiketimes)

% timestamps=[-1.22 0.33 0.34 0.35 0.40 3.70 7.30]; % sec
% timestamps2=timestamps+2;
% timestamps = [timestamps; timestamps2];

figure(3); close;

srate=10;      % number of time points per msec 
min_timevec = floor(min(spiketimes(:,1)));
max_timevec = ceil(max(spiketimes(:,1)));
% min_timevec=200;  % msec
% max_timevec=2000;   % msec
sigma=2;       % msec standard deviation of gaussian
peak=1;  %value of the peak of the gaussian (use peak=0 for gaussian 
%       integral = 1; thus sum(trace) is equal to the number of spikes) 
 
traces = zeros(n,(max_timevec-min_timevec)*srate+1);
 
 for i = 1:n
    stimes=spiketimes(spiketimes(:,2)==i,1);
    [trace,timevec,~]=spikegauss(stimes,srate,min_timevec,max_timevec,sigma,peak);
    traces(i,:) = trace';

     figure(3) 
     subplot(2,1,1)
     hold on
     plot(timevec,traces(i,:))
     title('spike trace for each cell')

 end
 figure(3); hold off;

 traces_all = mean(traces);
 figure(3)
 subplot(2,1,2)
 plot(timevec,traces_all)
 title('averaged spike trace')
 
 figure(3)
 hold off 

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [spkvec,timevec,updatedpeak]=spikegauss(timestamps,srate,min_timevec,max_timevec,sigma,peak)
% Generate SPKVEC time series from TIMESTAMPS. 
%
% Syntax: 
%    [spkvec,timevec,updatedpeak]=spikegauss(timestamps,srate,min_timevec,max_timevec,sigma,peak)
%
% Each spike is represented by a gaussian centered on each of the TIMESTAMPS
% SRATE is the sampling rate of the generated time series
% MIN_TIMEVEC and MAX_TIMEVEC are the limits the generated time series
% SIGMA is the standard deviation
% PEAK is the value of the peak of the gaussian (use peak=0 for gaussian
% integral = 1; thus sum(spkvec) is equal to the number of spikes)
%
%
% Example:
%
%     timestamps=[-1.22 0.33 0.34 0.35 0.40 3.70 7.30]; % sec
%     srate=1000;      % Hz 
%     min_timevec=-4;  % sec
%     max_timevec=8;   % sec
%     sigma=0.1;       % sec
%     peak=0;
%
%  [spkvec,timevec,updatedpeak]=spikegauss(timestamps,srate,min_timevec,max_timevec,sigma,peak);
%
%     plot(timevec,spkvec,'k')
%     hold on
%     plot([min_timevec max_timevec],[1 1]*updatedpeak,'-r')
%     plot(timestamps,rand(size(timestamps))/10*updatedpeak+updatedpeak,'ob')
%     hold off
%
% Doubts, bugs: rpavao@gmail.com

    timevec = min_timevec : 1/srate : max_timevec;
    spike_count = histc( timestamps, timevec );

    %gaussian kernel (mean=0; sigma from input)
    gk_mu    = 0;      
    gk_sigma = sigma;
    gk_x = -10*sigma+1/srate : 1/srate : +10*sigma;
    gk = 1/(sqrt(2*pi)* gk_sigma ) * exp( - (gk_x-gk_mu).^2 / (2*gk_sigma^2));
    if peak==0
        gk=gk/sum(gk);
    else
        gk=peak*gk/max(gk);
    end
    updatedpeak=max(gk);
    spkvec=conv( spike_count , gk, 'same'); 
end