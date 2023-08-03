function installMRTToolbox
% installMRTToolbox Install and setup the Mobile Robotics Training
% Toolbox
% Syntax: >> installMRTToolbox
% This command installs the Mobile Robotics Training Toolbox and compiles a
% the source C-code of a library block using the MEX command. The
% compilation step requires a supported compiler. You will
% be prompted to install a compiler if one doesn't exist already.

% Copyright 2017 The MathWorks, Inc.


disp('***************************************');
disp('Mobile Robobotics Training Toolbox');
disp('(1/2)Installing the toolbox...')

%% Installation of the MRT Toolbox
% Check for all the installed toolboxes
tb = matlab.addons.toolbox.installedToolboxes;
%Check if MRT toolbox is installed 
if isempty(find(arrayfun(@(n) strcmp(tb(n).Name, 'Mobile Robotics Training Toolbox'), 1:numel(tb))))
    %Install MRT toolbox 
    matlab.addons.toolbox.installToolbox('Mobile Robotics Training Toolbox.mltbx');
    disp('(1/2) Install is completed.')
else
    disp('(1/2) Install was completed previously.')    
end


%% Setting up the compilation of Real Time Slower block source code
disp('(2/2)Setting up ...');
try
    %Compile the source C-code for the Real Time Slower block
    mex([fileparts(which('mobileRoboticsTrainingLib')), filesep,'RealTimeSlower', filesep,'sfun_time.c']);
    movefile([pwd, filesep, 'sfun_time.', mexext], [fileparts(which('mobileRoboticsTrainingLib')),...
              filesep,'RealTimeSlower', filesep,  'sfun_time.', mexext]);
    
catch ME
    customMsg = ['Error: A compiler is required to complete this step. ', newline, ...
                 'Complete installing the compiler, restart MATLAB, '...
                 'and then try installMRTToolbox command again.', newline];
             
             switch ME.identifier
                 %Error if a supported compiler is not installed.
                 case 'MATLAB:mex:NoCompilerFound_link_Win64'
                     error([customMsg , newline...
                         'You can install the freely available MinGW-w64 C/C++ compiler on a PC; '...
                         'see <a href="https://www.mathworks.com/matlabcentral/fileexchange/52848-matlab-support-for-the-mingw-w64-c-c++-compiler-from-tdm-gcc-%3E-see-important-note">Install MinGW-w64 Compiler</a>. For compiler options on Mac and Linux, ' ...
                         'visit http://www.mathworks.com/support/compilers/R2017a/.'...
                         ]);
                 case 'MATLAB:mex:NoCompilerFound_Win64'
                     error([customMsg, newline...
                         'You can install the freely available MinGW-w64 C/C++ compiler; '...
                         'visit https://www.mathworks.com/matlabcentral/fileexchange/52848-matlab-support-for-the-mingw-w64-c-c++-compiler-from-tdm-gcc-%3E-see-important-note. '...
                         'For more options, visit https://www.mathworks.com/support/compilers. '...
                         ]);
                 case 'MATLAB:mex:NoCompilerFound_link'
                     error([customMsg , newline...
                         'For supported compiler options on Mac and Linux, visit <a href="https://www.mathworks.com/support/compilers">'...
                         'https://www.mathworks.com/support/compilers</a>.'...
                         ]);
                 case 'MATLAB:mex:NoCompilerFound'
                     error([customMsg , newline...
                        'For supported compiler options on Mac and Linux, visit https://www.mathworks.com/support/compilers. '...               ...
                         ]);
                     
                 otherwise
                     %       fprintf(2,['NOTE: If you are prompted in the error below to install a compiler- \n'...
                     %                  '1. complete installing the compiler, \n2. restart MATLAB, and'...
                     %                  '\n3. run installMRTToolbox command again. \n\n']);
                     rethrow(ME);
             end
end
disp('(2/2) Setting up completed.')
disp('Mobile Robotics Training Toolbox is ready for use!')
disp('***************************************');

