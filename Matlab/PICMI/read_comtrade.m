function read_comtrade
% - 11.02.2013 15:12 - changed 
% - ?sscanf(CfgFileName,'%1s'? to
% - ?sscanf(CfgFileName,'%1c'? to work with filenames with spaces
% - 04.03.2014 16:19 -  replace invalid (encoded as 9999999999 in COMTRADE) values with zeros
% - 
%% Comtrade Reader function
% 
% This file is designed to decode the data stored in COMTRADE format, 
% as defined in IEEE C37.111-1999. This involves the opening of two files, 
% one containing the configuration (.cfg) information and the other 
% the data (.dat).
% 
% COMTRADE provides a common format for the data files and exchange medium 
% needed for the interchange of various types of fault, test, or simulation 
% data.

%% open the comtrade files & extract the data

% read_comtrade(filename)
%  Imports data from the specified file
%  filename:  files to read <filename>.cfg and <filename>.dat

%  Auto-generated by MATLAB on 12-Jul-2007 13:45:45

% Use the uigetfile function to load the .cfg file, which is then used to
% load the associated .dat file

% First, get the .cfg file information
[CfgFileName,Path] = uigetfile('*.cfg');
PathAndCfgName =[Path CfgFileName];

% Derive the .dat file string
DatFileName = strcat(sscanf(CfgFileName,'%1c',length(CfgFileName)-4), '.dat');
PathAndDatName =[Path DatFileName];

% Store the file name (minus extension) and path in the workspace
assignin('base','Path', Path);
assignin('base','FileName', sscanf(CfgFileName,'%1c',length(CfgFileName)-4));

% Now open the .cfg and .dat files
cfg_id = fopen(PathAndCfgName);
dat_id = fopen(PathAndDatName);

% Scan the text into local cells cfg and dat.
cfg = textscan(cfg_id, '%s', 'delimiter', '\n');
dat = textscan(dat_id, '%s', 'delimiter', '\n');

% close all open files, as we're done with them now.
fclose('all');

%% start to decode the data

cfg_len = length(cfg{1,1});
cfg_string = cell(size(cfg));

for i = 1:cfg_len
    temp_string = char(cfg{1,1}{i});
    cfg_string(i) = textscan(temp_string, '%s', 'Delimiter', ',')';
end

% Comtrade File Identifier
Title = char(cfg_string{1,1}(1));

% Comtrade Version
if length(cfg_string{1,1}) < 3 %#ok<ISMT>
    Version = '1999';
else
    Version = char(cfg_string{1,1}(3));
end

% Channel information: total, analogues and digitals
No_Ch = strread(char(cfg_string{1,2}(1)));
Ana_Ch = strread(char(cfg_string{1,2}(2)));
Dig_Ch = strread(char(cfg_string{1,2}(3)));

% Data length, i.e. no of samples
dat_len = strread(char(cfg_string{1,5+No_Ch}(2))); 

% Nominal frequency 
frequency = strread(char(cfg_string{1,3+No_Ch}(1)));

% Sampling rate
samp_rate = strread(char(cfg_string{1,5+No_Ch}(1)));

% Record started
start_date = char(cfg_string{1,6+No_Ch}(1));
start_time = char(cfg_string{1,6+No_Ch}(2));

% Record ended
end_date = char(cfg_string{1,7+No_Ch}(1));
end_time = char(cfg_string{1,7+No_Ch}(2));


%% Now write the data to the workspace

dat_string = cell(size(dat));
data = zeros(dat_len, No_Ch+2);

% Now extract the data
for i = 1:dat_len
    dat_string(i) = textscan(char(dat{1,:}(i)), '%n', 'Delimiter', ',');
    data(i,:) = (dat_string{:,i});
end

% extract the timestamps, scaled to seconds from microseconds
t = (data(:,2)) * 1e-6;

% Write the data to the workspace
assignin('base','t', t);

var_string = cell(No_Ch);

% All channels are extracted here, but the analogues still need scaling
 for i = 1 : No_Ch
 
    j = i + 2;
 
    var_string{i} = char(textscan(char(cfg_string{1,j}(2)),'%c'));
    
    % If the first character is not a letter, replace with an 'x'. This is
    % to satisfy the naming requirements for the workspace.
    if ~isletter(var_string{i}(1))
        var_string{i}(1) = 'x';
    end
    % If any character is not a letter or number, replace with an '_'. This is
    % to satisfy the naming requirements for the workspace.
    for k = 2:length(var_string{i})
        if ~isstrprop(var_string{i}(k), 'alphanum')
            var_string{i}(k) = '_';
        end
    end
    
    assignin('base', var_string{i}, data(:,j));
 end

%% Write the remainaing config information to the workspace

assignin('base','Title', Title);
assignin('base','Version', Version);
assignin('base','Total_Channels', No_Ch);
assignin('base','Analogue_Channels', Ana_Ch);
assignin('base','Digital_Channels', Dig_Ch);
assignin('base','Frequency', frequency);
assignin('base','Sample_rate', samp_rate);
assignin('base','Start_date', start_date);
assignin('base','Start_time', start_time);
assignin('base','End_date', end_date);
assignin('base','End_time', end_time);
assignin('base','config', (cfg_string'));

%% Now let's post-process the data to produce the final waveforms

hold off;
close all;
% replace invalid (encoded as 9999999999 in COMTRADE) values with zeros
data(data==9999999999) = 0;

if Ana_Ch >= 1

    dat = zeros(dat_len, Ana_Ch+2);
    
    % step through the data configuration
    for i = 1 : Ana_Ch

        j = i + 2;
    
        % Limit the range of the result
        min_level = cell2mat(textscan(char(cfg_string{1,j}(9)),'%d'));
        max_level = cell2mat(textscan(char(cfg_string{1,j}(10)),'%d'));
        
        % The value is scaled by the equation [aX + b]
        multiplier = cell2mat(textscan(char(cfg_string{1,j}(6)),'%f')); % a
        offset = cell2mat(textscan(char(cfg_string{1,j}(7)),'%f'));     % b
        
        % Lower limit check
        if data(:,j) <= min_level
            data(:,j) = min_level;
        end

        % Upper limit check
        if data(:,j) >= max_level
           data(:,j) = max_level;
        end
        
        
        dat(:,i) = data(:,j) * multiplier  + offset;

        % If the Primary and Secondary scaling information is present,
        % apply that too
        if length(cfg_string{1,j}) > 10

            pri_scaling = cell2mat(textscan(char(cfg_string{1,j}(11)),'%f'));
            sec_scaling = cell2mat(textscan(char(cfg_string{1,j}(12)),'%f'));
            pri_sec = char(cfg_string{1,j}(13));

            if pri_sec == 'P' 

                dat(:,i) = dat(:,i) * pri_scaling;

            else

                dat(:,i) = dat(:,i) * sec_scaling;

            end
        end

        assignin('base', var_string{i}, dat(:,i));

    end
end

% 
% %% And finally, plot the results. 
% % Analogues in multiple subplots (V, I, Other) in first figure. 
% % Digitals in 8 subplots per figure 
% 
% if No_Ch >= 1
%     
% 
%     %    Initialise local variables 
%     colour = 'null';
%     colour_v = 'null';
%     colour_i = 'null';
%     colour_x = 'null';
%     
%     no_plots = 1;
%     
%     count = 9;
%     sub_plot = 1;
% 
%     % Pops up a menu dialog, allowing the user to choose which plots to
%     % display
%     x = menu('What do you want to plot?','Nothing','Analogue Channels','Digital Channels','All Channels');
%     
%     switch (x)
%         % Don't plot anything
%         case 1
%             start_count = 1;
%             target_count = 1;
%         % Analogue channels only
%         case 2
%             start_count = 1;
%             target_count = Ana_Ch;
%         % Digital channels only
%         case 3
%             start_count = Ana_Ch + 1;
%             target_count = No_Ch;
%         % Analogue & digital channesl
%         case 4
%             start_count = 1;
%             target_count = No_Ch;
%         % Default case - will never happen
%         otherwise
%             start_count = -1;
%             target_count = -1;
%     end
%     
%     if x > 1
% 
%         % Only need to work out the number of plots if we're going to plot
%         % the analogue channels
%         if x == 2 || x == 4
% 
%             for i = 1 : Ana_Ch
% 
%                 j = i + 2;
% 
%                 % scan data types. This way we know how many graphs to plot in the analogues figure.
%                 switch char(cfg_string{1,j}(5)) 
% 
%                     case 'V'
% 
%                     case 'A'
%                         if no_plots < 2
%                             no_plots = 2;
%                         end
% 
%                     otherwise
%                         if no_plots < 3
%                             no_plots = 3;
%                         end
%                 end
%             end
% 
%             figure(1);hold on;
% 
%         end
% 
%         p = cell(No_Ch,1);
%         
%         % Scan through the data and plot.
%         for i = start_count : target_count
% 
%             j = i + 2;
% 
%             if i <= Ana_Ch
% 
%                 % Plot the analogue channels
%                 switch char(cfg_string{1,j}(5)) 
% 
%                     case 'V'
%                     colour_v = get_colour(colour_v);
%                     colour = colour_v;
%                     sub_plot = 1;
% 
%                     case 'A'
%                     colour_i = get_colour(colour_i);
%                     colour = colour_i;
%                     sub_plot = 2;
% 
%                     otherwise
%                     colour_x = get_colour(colour_x);
%                     colour = colour_x;
%                     sub_plot = 3;
% 
%                 end
%                 hold on;
% 
%                 subplot(no_plots, 1, sub_plot), p{1,1}(i) = plot(t, evalin('base', var_string{i}), 'color', colour);
% 
%             else
% 
%                 % Plot the digital channels.
%                 if count > 8
%                     figure(); hold on;
%                     sub_plot = 1;
%                     count = 1;
%                     colour = 'null';
%                 end
% 
%                 colour = get_colour(colour);
% 
%                 subplot(8, 1, sub_plot), p{1} = plot(t, evalin('base', var_string{i}), 'color', colour);
% 
%                 sub_plot = sub_plot + 1;
%                 count = count + 1;
%             end
% 
%             % Read the current legend
%             y = get(legend, 'string');
% 
%             % Append the new item to the legend for this plot.
%             legend_string = char(cfg_string{1,j}(2));
%             legend(p{i,1},[y, legend_string]);
%         end
%     end
% end

%% Colour function
% Steps through the colour palette in a defined order. Traditionally power
% systems use Red Yellow Blue for the 3 phase representation of waveforms.

function new_colour = get_colour(colour)

switch colour
    case 'null'
        new_colour = 'blue';
    case 'red'
        new_colour = 'red';
    case 'yellow'
        new_colour = 'green';
    case 'blue'
        new_colour = 'magenta';
    case 'green'
        new_colour = 'cyan';
    case 'cyan'
        new_colour = 'yellow';
    case 'magenta'
        new_colour = 'black';
    case 'black'
        new_colour = 'red';
    otherwise
        new_colour = 'red';
end
