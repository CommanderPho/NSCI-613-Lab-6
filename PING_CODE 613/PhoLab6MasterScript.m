%% NSCI 613 Lab 6 - Meta/Master Script
clear all;

figure_parent_export_path = '/Users/pho/Dropbox/Classes/Fall 2020/NSCI 613 - Neurophysiology and Computational Neuroscience/Lab 6/Results';

active_problem_i = 3;

bShouldShowRasterPlot = false;
bShouldSaveRasterPlots = false;

bSaveLoopResults = true;
bShouldExportFigures = true;

active_problem_indicies = {'1a', '1b', '1c', '2a', '2b'};
changed_variable_names = {'tau_d_i_value', 'Iapp_e', 'Iapp_i', 'p_ei', 'p_ie'};
changed_variable_descriptions = {'Inhibitory Decay Time Constant \tau_{di}', 'Intrinsic E-cell firing frequency Iapp_e', 'Intrinsic I-cell firing frequency Iapp_i', 'p_ei', 'p_ie'};

changed_variable_name = changed_variable_names{active_problem_i};
changed_variable_descr_string = changed_variable_descriptions{active_problem_i};
active_problem_index = active_problem_indicies{active_problem_i};

%% Problem 1

if active_problem_index == '1a'
	tau_d_i_value_vec = 9:1:60;
% 	tau_d_i_value_vec = 60;
	active_vec = tau_d_i_value_vec;	
elseif active_problem_index == '1b'
	Iapp_e_vec = 2:1:10;
	active_vec = Iapp_e_vec;
elseif active_problem_index == '1c'
	Iapp_i_vec = 0:1:10;
	active_vec = Iapp_i_vec;
elseif active_problem_index == '2a'
	p_ei_vec = 0.1:0.1:1;
	active_vec = p_ei_vec;
elseif active_problem_index == '2b'
	p_ie_vec = 0.1:0.1:1;
	active_vec = p_ie_vec;	
else
	error('Unknown problem index!')
end

num_iterations = length(active_vec);

% Pre-allocate:
avnfreq_vec = zeros([num_iterations 1]);

mean_crcorr_vec = zeros([num_iterations 1]);
mean_GolombBursting_B_vec = zeros([num_iterations 1]);


if bSaveLoopResults
% 		spiketimes_i_vec
% 		spiketimes_i %176x2
% 		spiketimes_e % 760x2
% 		spiketimes_e2 % 718x2
% 		
% 		spiketimes_e2_results = {};
end

if bShouldSaveRasterPlots
	raster_plot_figure_parent_export_path = fullfile(figure_parent_export_path, 'rasterplots');
	if ~exist(raster_plot_figure_parent_export_path,'dir')
		mkdir(raster_plot_figure_parent_export_path); 
	end
end

for loop_iteration = 1:num_iterations

	if active_problem_index == '1a'
		params2
	elseif active_problem_index == '1b'
		params2
	elseif active_problem_index == '1c'
		params2
	else
		% For all problem 2 problems, use params 3
		params3
	end
	
	gamma_simulator
	% Save results:
	avnfreq_vec(loop_iteration) = avnfreq;
	
	[timevec, traces, traces_all, GolombBursting, crcorr] = PINGSynchronyMeasures(num_e, spiketimes_e2);
	mean_crcorr_vec(loop_iteration) = crcorr.mean;
	mean_GolombBursting_B_vec(loop_iteration) = GolombBursting.B;
	
	if bSaveLoopResults
% 		spiketimes_i
% 		spiketimes_e2_results{end+1} = spiketimes_e2;
	end
	
	if active_problem_index == '1a'
		curr_loop_value = tau_d_i_value;
	elseif active_problem_index == '1b'
		curr_loop_value = Iapp_e;
	elseif active_problem_index == '1c'
		curr_loop_value = Iapp_i;
	elseif active_problem_index == '2a'
		curr_loop_value = p_ei;
	elseif active_problem_index == '2b'
		curr_loop_value = p_ie;
	else
% 		continue
		error('Unknown problem index!')
	end
	fprintf(['Average E network frequency in Hz for ' changed_variable_name ': %g is %10.3f \n'], curr_loop_value, avnfreq)
	
	if bShouldShowRasterPlot
		active_var_string = sprintf([changed_variable_name ': %g'], curr_loop_value);
		title(active_var_string)
		if bShouldSaveRasterPlots
			curr_raster_plot_file_name = sprintf(['%s_' changed_variable_name '_%g'], active_problem_index, curr_loop_value);
			curr_raster_plot_figure_export_path = fullfile(raster_plot_figure_parent_export_path, curr_raster_plot_file_name);
			fnSaveFigureForExport(gcf, curr_raster_plot_figure_export_path, false, false, false, true);
		end
	end
end

% figure_1_matfile_path = fullfile(figure_parent_export_path, [active_problem_index '_data.mat']);
% load(figure_1_matfile_path);
% 
% % Save the frequencies to average them across multiple runs:
% if ~exist('multi_trial_frequencies','var')
% 	multi_trial_frequencies = avnfreq_vec;
% else
% 	multi_trial_frequencies = [multi_trial_frequencies avnfreq_vec];
% end
% 
% % Save it out
% save(figure_1_matfile_path, 'multi_trial_frequencies');
% 
% % Compute trial means:
% %mean(multi_trial_frequencies,2)
% avnfreq_vec = mean(multi_trial_frequencies,2); % Average over all trials


%% Extra Problem 1b thingy:
% Allows accumulating results
if (active_problem_index == '1b')
    figure_1b_matfile_path = fullfile(figure_parent_export_path, [active_problem_index '_data.mat']);
    load(figure_1b_matfile_path);

    % Save the frequencies to average them across multiple runs:
    if ~exist('multi_trial_frequencies','var')
        multi_trial_frequencies = avnfreq_vec;
         multi_trial_tau_d_i_values = [tau_d_i_value];
    else
        multi_trial_frequencies = [multi_trial_frequencies avnfreq_vec];
        multi_trial_tau_d_i_values = [multi_trial_tau_d_i_values tau_d_i_value];
    end

    % Save it out
    save(figure_1b_matfile_path, 'multi_trial_tau_d_i_values', 'multi_trial_frequencies');

%     % Make custom plot:
%     fig_h = figure(3);
%     legend_1b = {'9','21','39','59'};
%   
%     plot(active_vec, multi_trial_frequencies(:,13));
%     hold on
%     plot(active_vec, multi_trial_frequencies(:,14));
%     plot(active_vec, multi_trial_frequencies(:,15));
%     plot(active_vec, multi_trial_frequencies(:,16));
%     hold off
%  
%     ylabel('Average Network Frequency [Hz]')
% 	title(['Problem ' active_problem_index ' - Further effect of tau_di_i'])
%     xlabel(changed_variable_descr_string)
%     lg = legend(legend_1b);
%     title(lg, 'tau_di_i')
end


% Make plot

fig_h = figure(2);
if (strcmp(active_problem_index,'1a') || strcmp(active_problem_index,'1b') || strcmp(active_problem_index,'1c'))
	plot(active_vec, avnfreq_vec)
	ylabel('Average Network Frequency [Hz]')
	title(['Problem ' active_problem_index])
    xlabel(changed_variable_descr_string)
else
	subplot(2,1,1)
	plot(active_vec, mean_crcorr_vec)
	ylabel('Mean Cross-Correlation')
	title('Mean Cross-Correlation')
	xlabel(changed_variable_descr_string)
	
	subplot(2,1,2)
	plot(active_vec, mean_GolombBursting_B_vec)
	ylabel('Golomb Bursting B')
	title('Golomb Bursting B')
	xlabel(changed_variable_descr_string)
	sgtitle(['Problem ' active_problem_index])
end


if bShouldExportFigures
	figure_1_export_path = fullfile(figure_parent_export_path, active_problem_index);
	fnSaveFigureForExport(fig_h, figure_1_export_path, false, false, false, true);
end