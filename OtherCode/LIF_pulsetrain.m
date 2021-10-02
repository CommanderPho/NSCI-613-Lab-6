function [t_all,v_all,Iapp_all]=LIF_pulsetrain(pulsei,period,dur)

% Parameter values
cm=1;
gl=0.01; %rm

Erest=-65; %E_ion
vthresh=-55;
vreset=-70;
% ton=25;
% toff=1025;

%The initial values for v
v=-65;

% set up time of simulation = tend, time step = deltat, and number of
% solution points computed totalpts
tend=1000;
deltat=0.2;
totalpts=tend/deltat;
t_all=(0:deltat:tend-deltat)';

% set vector of applied current values
Iapp_all = zeros(totalpts, 1);
inds = mod(t_all,period) < dur;
Iapp_all(inds) = pulsei;

%Initialize the vector that will contain the membrane potential time series.
v_all=zeros(totalpts, 1);


% step through time vector t_out to compute solution
for i=1:totalpts
    % set t to the current time value and Iapp to current value
    t = t_all(i);
    Iapp = Iapp_all(i);
    %save to v_all the current value of v
    v_all(i)=v;
    %Reset v if v has crossed threshold. 
    if (v>= vthresh)
        v=vreset;
    end
    
    %Use Euler’s method to integrate eq. 
    v=v+deltat*(-gl*(v-Erest)+ Iapp)/cm;
end

     function h=uheavi(x)
        if x>=0
            h=1.0;
        else
            h=0;
        end
    end
       
%Plot the neuron’s membrane potential.
figure(6)
plot(t_all,v_all);
hold on
plot(t_all,Iapp_all-65)
hold off


end