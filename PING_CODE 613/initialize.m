v_e=-80+rand(num_e,1)*30;
n_e=0*ones(num_e,1);
m_e=m_e_inf(v_e);
h_e=0*ones(num_e,1);
s_e=zeros(num_e,1);

v_i=-80+rand(num_i,1)*30;
n_i=0*ones(num_i,1);
m_i=m_i_inf(v_i);
h_i=0*ones(num_i,1);
s_i=zeros(num_i,1);
s_stoch_e=zeros(num_e,1);
s_stoch_i=zeros(num_i,1);


num_spikes_e=0;
num_spikes_i=0;

