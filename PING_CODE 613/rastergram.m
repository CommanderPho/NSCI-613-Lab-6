if num_spikes_i>0, plot(t_i_spikes,i_i_spikes,'.b'); hold on; end;
if num_spikes_e>0, plot(t_e_spikes,i_e_spikes+num_i,'.r');  hold on; end; 
if num_e>0 && num_i>0, plot([0,t_final],[num_i+1/2,num_i+1/2],'--k','Linewidth',1); end;
hold off;

set(gca,'Fontsize',12); 
axis([0,t_final,0,num_e+num_i+1]); 


if num_e<4 || num_i<4, 
	set(gca,'Ytick',[num_e+num_i]);
else
	set(gca,'Ytick',[num_i,num_e+num_i]);
end;

shg;

