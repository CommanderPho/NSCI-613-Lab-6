% gamma_simulator.m

% clear; 
%tic; 

% set the random number seeds
% comment out below to generate new random number sequences with each run
%rand('twister',5489); randn('state',0); 

% uncomment name of parameter file to run
% params0;
% params1; 
% params2;
% params3;

dt05=dt/2;
m_steps=floor(t_final/dt+0.1);
r_e=exp(-dt05/tau_d_stoch_e);
r_i=exp(-dt05/tau_d_stoch_i);

% set synaptic conductances

g_ee=g_hat_ee*ones(num_e,num_e).*(sign(p_ee-rand(num_e,num_e))+1)/2/(p_ee*num_e);
g_ei=g_hat_ei*ones(num_e,num_i).*(sign(p_ei-rand(num_e,num_i))+1)/2/(p_ei*num_e);
g_ie=g_hat_ie*ones(num_i,num_e).*(sign(p_ie-rand(num_i,num_e))+1)/2/(p_ie*num_i);
g_ii=g_hat_ii*ones(num_i,num_i).*(sign(p_ii-rand(num_i,num_i))+1)/2/(p_ii*num_i);

% initialize dynamic variables

clear i_i_spikes t_i_spikes i_e_spikes t_e_spikes range num_spikes_i num_spikes_e
initialize; 

% solve the system of Hodgkin-Huxley-like equations using the midpoint method

for k=1:m_steps
    t_old=(k-1)*dt;
    t_new=k*dt;
    t_mid=(t_old+t_new)/2;
    

	v_e_inc=0.1*(-67-v_e)+80*n_e.^4.*(-100-v_e)+100*m_e.^3.*h_e.*(50-v_e) ...
               +(g_ee'*s_e).*(v_rev_e-v_e)+(g_ie'*s_i).*(v_rev_i-v_e) ...
               +I_e(t_old)+g_stoch_e*s_stoch_e.*(v_rev_e-v_e);
	n_e_inc=(n_e_inf(v_e)-n_e)./tau_n_e(v_e);
    h_e_inc=(h_e_inf(v_e)-h_e)./tau_h_e(v_e);
    s_e_inc=0.5*(1+tanh(v_e/4)).*(1-s_e)./tau_r_e-s_e./tau_d_e; 
	v_i_inc=0.1*(-65-v_i)+9*n_i.^4.*(-90-v_i)+35*m_i.^3.*h_i.*(55-v_i) ...
               +(g_ei'*s_e).*(v_rev_e-v_i)+(g_ii'*s_i).*(v_rev_i-v_i) ...
               +I_i(t_old)+g_stoch_i*s_stoch_i.*(v_rev_e-v_i);
	n_i_inc=(n_i_inf(v_i)-n_i)./tau_n_i(v_i);
    h_i_inc=(h_i_inf(v_i)-h_i)./tau_h_i(v_i);
    s_i_inc=0.5*(1+tanh(v_i/4)).*(1-s_i)./tau_r_i-s_i./tau_d_i;

	v_e_tmp=v_e+dt05*v_e_inc;
	n_e_tmp=n_e+dt05*n_e_inc;
	m_e_tmp=m_e_inf(v_e_tmp);
    h_e_tmp=h_e+dt05*h_e_inc;
    s_e_tmp=s_e+dt05*s_e_inc;    
	v_i_tmp=v_i+dt05*v_i_inc;
	n_i_tmp=n_i+dt05*n_i_inc;
	m_i_tmp=m_i_inf(v_i_tmp);
    h_i_tmp=h_i+dt05*h_i_inc;
    s_i_tmp=s_i+dt05*s_i_inc;   
    s_stoch_e=s_stoch_e*r_e; s_stoch_i=s_stoch_i*r_i;

	v_e_inc=0.1*(-67-v_e_tmp)+80*n_e_tmp.^4.*(-100-v_e_tmp)+100*m_e_tmp.^3.*h_e_tmp.*(50-v_e_tmp) ...
               +(g_ee'*s_e_tmp).*(v_rev_e-v_e_tmp)+(g_ie'*s_i_tmp).*(v_rev_i-v_e_tmp) ...
               +I_e(t_mid)+g_stoch_e*s_stoch_e.*(v_rev_e-v_e_tmp);
	n_e_inc=(n_e_inf(v_e_tmp)-n_e_tmp)./tau_n_e(v_e_tmp);
    h_e_inc=(h_e_inf(v_e_tmp)-h_e_tmp)./tau_h_e(v_e_tmp);
    s_e_inc=0.5*(1+tanh(v_e_tmp/4)).*(1-s_e_tmp)./tau_r_e-s_e_tmp./tau_d_e; 
	v_i_inc=0.1*(-65-v_i_tmp)+9*n_i_tmp.^4.*(-90-v_i_tmp)+35*m_i_tmp.^3.*h_i_tmp.*(55-v_i_tmp) ...
               +(g_ei'*s_e_tmp).*(v_rev_e-v_i_tmp)+(g_ii'*s_i_tmp).*(v_rev_i-v_i_tmp) ...
               +I_i(t_mid)+g_stoch_i*s_stoch_i.*(v_rev_e-v_i_tmp);
	n_i_inc=(n_i_inf(v_i_tmp)-n_i_tmp)./tau_n_i(v_i_tmp);
    h_i_inc=(h_i_inf(v_i_tmp)-h_i_tmp)./tau_h_i(v_i_tmp);
    s_i_inc=0.5*(1+tanh(v_i_tmp/4)).*(1-s_i_tmp)./tau_r_i-s_i_tmp./tau_d_i;
        
    v_e_old=v_e;
    v_i_old=v_i;

	v_e=v_e+dt*v_e_inc;
	n_e=n_e+dt*n_e_inc;
	m_e=m_e_inf(v_e);
    h_e=h_e+dt*h_e_inc;
    s_e=s_e+dt*s_e_inc;
	v_i=v_i+dt*v_i_inc;
	n_i=n_i+dt*n_i_inc;
	m_i=m_i_inf(v_i);
    h_i=h_i+dt*h_i_inc;
    s_i=s_i+dt*s_i_inc;
    s_stoch_e=s_stoch_e*r_e;
    s_stoch_i=s_stoch_i*r_i;
    u_e=rand(num_e,1); u_i=rand(num_i,1);
	s_stoch_e=s_stoch_e+max(sign(f_stoch_e*dt/1000-u_e),0).*(1-s_stoch_e);
	s_stoch_i=s_stoch_i+max(sign(f_stoch_i*dt/1000-u_i),0).*(1-s_stoch_i);

	% determine which and how many e- and i-cells spiked in the current time step

    which_e=find(v_e_old<0 & v_e >=0);
    which_i=find(v_i_old<0 & v_i >=0);
    l_e=length(which_e);
    l_i=length(which_i);

    if l_e>0 
        range=[num_spikes_e+1:num_spikes_e+l_e];
		i_e_spikes(range)=which_e; 
        t_e_spikes(range)=(v_e(which_e)*(k-1)*dt-v_e_old(which_e)*k*dt)./(v_e(which_e)-v_e_old(which_e));
        num_spikes_e=num_spikes_e+l_e;
    end 

    if l_i>0 
        range=[num_spikes_i+1:num_spikes_i+l_i];
 		i_i_spikes(range)=which_i; 
        t_i_spikes(range)=(v_i(which_i)*(k-1)*dt-v_i_old(which_i)*k*dt)./(v_i(which_i)-v_i_old(which_i));
        num_spikes_i=num_spikes_i+l_i;
    end 

end

%% Record the results



% plot the spike rastergram

if bShouldShowRasterPlot
	figure(1)
	rastergram;
end

% construct spiketime vectors
spiketimes_i=[t_i_spikes', i_i_spikes'];
spiketimes_e=[t_e_spikes', i_e_spikes'];

% compute average E network frequency between t=50 and t=200msec
spiketimes_e2=spiketimes_e(spiketimes_e(:,1)>50.0,:);
nisis=diff(spiketimes_e2(:,1));
nisis=nisis(nisis>0.1);
avnfreq=1/(mean(nisis)/1000);

%toc;
