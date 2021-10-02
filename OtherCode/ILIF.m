function [t, v]=ILIF(pulsei)

% parameter sets for different neuron firing patterns 
% neocortical pyramidal neuron - no spike at current step
C=100; vr=-60; vt=-40; k=0.7; a=0.03; b=-2; c=-50; d=100; vpeak=35;

% neocortical pyramidal neuron - with spike at current step
%C=100; vr=-60; vt=-40; k=0.7; a=0.03; b=5; c=-50; d=100; vpeak=35;

% intrinsically bursting neuron
%C=150; vr=-75; vt=-45; k=1.2; a=0.01; b=5; c=-56; d=130; vpeak=50;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% numerical solution of model

ton=25; toff=1000; % on and off times for current pulse

T=1000; deltat=1; % time span and step (ms) 
n=round(T/deltat); % number of simulation steps 
v=zeros(1,n); u=zeros(1,n); %set up output vectors
v(1)=vr; % u(1)=0 initial values 

for i=1:n-1 % forward Euler method 
    Iapp=pulsei*uheavi(i*deltat-ton)*uheavi(toff-i*deltat);
    v(i+1)=v(i)+deltat*(k*(v(i)-vr)*(v(i)-vt)-u(i)+Iapp)/C; 
    u(i+1)=u(i)+deltat*a*(b*(v(i)-vr)-u(i)); 
    if v(i+1)>=vpeak % a spike is fired! 
        v(i)=vpeak; % padding the spike amplitude 
        v(i+1)=c; % membrane voltage reset 
        u(i+1)=u(i+1)+d; % recovery variable update 
    end; 
end; 

t=deltat*(1:n);
figure(7)
%hold on
plot(t, v); % plot the result

     function h=uheavi(x)
        if x>=0
            h=1.0;
        else
            h=0;
        end
     end
    
% Izhikevich, Eugene M.. Dynamical Systems in Neuroscience : The Geometry of Excitability and Bursting.
% Cambridge, MA, USA: MIT Press, 2006. p 274.
% http://site.ebrary.com/lib/umich/Doc?id=10173655&ppg=291
% Copyright © 2006. MIT Press. All rights reserved. 
end