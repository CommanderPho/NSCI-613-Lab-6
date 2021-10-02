function [spiketimes]=ILIF_ExcNetwork(n,W)

%RUN by entering the following at the matlab command window prompt:
%  [spiketimes]=ILIF_ExcNetwork(n,W);

% Set model parameter values
a=0.02;
b=0.2;
c=-65;
d=8;
vthresh=30;

% set synapse parameter values
gsyn=0.0;
taus=5;

%%% set applied current, pulse or constant
% constant applied current
%Iapp = 4*ones(50,1);

%%% only cell 10 fires
Iapp = 2*ones(50,1);
Iapp(10)=4;

%%% random applied current
% Iapp = 4*ones(50,1)+rand(50,1);

%Set initial values for v & u
v=-70*ones(n,1) + 10*rand(n,1);
u=-14*ones(n,1) + 5*rand(n,1);
s=zeros(n,1);

% set time of simulation = tend, time step = deltat, and number of
% solution points computed totalpts
tend=2000;
deltat=0.1;
totalpts=tend/deltat;

% initialize storage vector 
%v_tot=zeros(totalpts,2);
%u_tot=zeros(totalpts,2);
%s_tot=zeros(totalpts,2);

spiketimes=[];
%spiketimes=zeros(n*totalpts,2);
%k=1;

% store initial values
%v_tot(1,:)=v';
%u_tot(1,:)=u';

% step through time to compute solution
for i=2:totalpts
    t=i*deltat;
    
    % uncomment if applied current pulse, comment otherwise
    %Iapp = pulsei*heavyside(t-ton)*heavyside(toff-t)*ones(n,1);
    
    %Use Euler’s method to integrate eq.
    v = v + deltat*(0.04*v.^2 + 5*v + 140 - u + Iapp + gsyn*W*s);
    u = u + deltat*(a*(b*v - u));
    %set v_tot,u_tot at this time point to the current value of v, u
    %v_tot(i,:)=v';
    %u_tot(i,:)=u';
    %check if any v has exceeded spike threshold. 
    fired=find(v>=vthresh);
    if ~isempty(fired)
        % reset cells that spiked
        v(fired)=c;
        u(fired)=u(fired)+d;
        % cut off spike peak to vpeak
        %v_tot(i,fired)=vpeak;
        % save spiketimes: [time of spike, cell that spiked]
        
        if isempty(spiketimes)
            spiketimes=horzcat(t*ones(length(fired),1), fired);
        else
            spiketimes=[spiketimes; t*ones(length(fired),1), fired];
        end
    end
    if ~isempty(spiketimes)
        % compute synaptic output for each cell
        for j=1:n
            cellout=spiketimes(spiketimes(:,2)==j,1);
            cellout=sum(exp(-(t-cellout)/taus));
            s(j)=cellout;
            %s_tot(i,:)=s';
        end
    end 
end


% Plot raster plot
figure(1)
plot(spiketimes(:,1),spiketimes(:,2),'.')
xlabel('time')
ylabel('neuron number')
% 
% %Plot the neuron’s membrane potential.
% figure(1)
% t_tot=[0:deltat:tend-deltat]';
% %t_tot=[0:deltat:tend-deltat]';
% plot(t_tot,v_tot(:,1),t_tot,v_tot(:,2),'r');
% 
% %compute interspike intervals
% cell1=spiketimes(spiketimes(:,2)==1,1);
% cell2=spiketimes(spiketimes(:,2)==2,1);
% isis1=diff(cell1);
% isis2=diff(cell2);

% heaviside function for current pulse
    function hside=heavyside(x)
            if x >= 0
                hside = 1;
            else
                hside = 0;
            end
        end
       

end