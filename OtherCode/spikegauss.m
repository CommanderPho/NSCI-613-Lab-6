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
