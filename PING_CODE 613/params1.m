%-----------------------------------
% number of E- and I-cells:
num_e=80; num_i=20;
%-----------------------------------



%-----------------------------------
% density of synaptic connections: 
p_ee=1.0; p_ei=1.0; p_ie=1.0; p_ii=1.0;
%-----------------------------------



%-----------------------------------
% rise and decay time constants associated with synapses:
tau_r_e=0.1*ones(num_e,1); tau_d_e=3*ones(num_e,1); 
tau_r_i=0.3*ones(num_i,1); tau_d_i=9*ones(num_i,1); 
%-----------------------------------



%-----------------------------------
% synaptic reversal potentials: 
v_rev_e=0; v_rev_i=-80;  
%-----------------------------------



%-----------------------------------
% time simulated (in ms):
t_final=200;  
%-----------------------------------



%-----------------------------------
% time step used in the midpoint method:
dt=0.02; 
%-----------------------------------



%-----------------------------------
% strength of synaptic connections: 
%g_hat_ie=1.5; g_hat_ei=0.5; g_hat_ii=0.5; g_hat_ee=0;
g_hat_ie=0.5; g_hat_ei=0.5; g_hat_ii=0.5; g_hat_ee=0;
%-----------------------------------



%-----------------------------------
% external drive to the E-cells:

% deterministic drive:
Iapp_e = 2.5;
I_e=@(t) Iapp_e*ones(num_e,1);

% sigma=1.5;
% I_e=@(t) sigma*rand(num_e,1);


% maximum conductance, decay time, and frequency of Poisson train of excitatory input pulses:
g_stoch_e=0; f_stoch_e=0; tau_d_stoch_e=3; 
%-----------------------------------



%-----------------------------------
% external drive to the I-cells:

% deterministic drive:
%I_i=@(t) zeros(num_i,1);
Iapp_i = 0;
I_i=@(t) Iapp_i*ones(num_i,1);

% maximum conductance, decay time, and frequency of Poisson train of excitatory input pulses:
g_stoch_i=0; f_stoch_i=0; tau_d_stoch_i=3; 
%-----------------------------------
