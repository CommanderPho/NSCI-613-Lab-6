function [t_tot,v_tot, spiketimes,spikeintervals]=LIF(pulsei)

%RUN by entering the following at the matlab command window prompt:
%  [t_tot,v_tot,spiketimes,spikeintervals]=LIF(amplitude of desired current pulse);

% Set model parameter values
cm=1;
gl=0.1;
EL=-65;
vthresh=-55;
vreset=-70;
% set time to start and end applied current pulse
ton=100;
toff=1100;

%Set initial value for v
v=-65;

% set time of simulation = tend, time step = deltat, and number of
% solution points computed totalpts
tend=1100;
deltat=0.2;
totalpts=tend/deltat;

%Initialize the vector that will contain the membrane potential time series.
v_tot=zeros(totalpts, 1);

% initialize vectors and index counter for spiketimes vector 
spiketimes=zeros(1,1);
j=1;

% step through time to compute solution
for i=1:totalpts
    %set v_tot at this time point to the current value of v
    v_tot(i)=v;
    %Reset v if v has crossed threshold. 
    if (v>= vthresh)
        v=vreset;
        % save spike time
        spiketimes(j)=i*deltat;
        j=j+1;
    end
    %Use Euler’s method to integrate eq. 
    v=v+deltat*(-gl*(v-EL)+ pulsei*heavyside(i*deltat-ton)*heavyside(toff-i*deltat))/cm;
end

% heaviside function for current pulse
    function hside=heavyside(x)
            if x >= 0
                hside = 1;
            else
                hside = 0;
            end
        end
       
%Plot the neuron’s membrane potential.
t_tot=(0:deltat:tend-deltat)';
plot(t_tot,v_tot);

%compute interspike intervals
spikeintervals=diff(spiketimes);

end