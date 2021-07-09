%% Create TPs
addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/Bayesian_Quant_Learning');
T_Precip_syn{1} = synthMatrix(0, 1, 1); % mod, std = 1
T_Precip_syn{2} = synthMatrix(0, 2, 1); % mod, std = 2
T_Precip_syn{3} = synthMatrix(0, 4, 1); % mod, std = 4

T_Precip_syn{4} = synthMatrix(3, 1, 1); % wet, std = 1
T_Precip_syn{5} = synthMatrix(3, 2, 1); % wet, std = 2
T_Precip_syn{6} = synthMatrix(3, 4, 1); % wet, std = 4

T_Precip_syn{7} = synthMatrix(-3, 1, 1); % dry, std = 1
T_Precip_syn{8} = synthMatrix(-3, 2, 1); % dry, std = 2
T_Precip_syn{9} = synthMatrix(-3, 4, 1); % dry, std = 4

%% Plot Each- 3 x 3

ScenName = {'Mod, Std = 1', 'Mod, Std = 2', 'Mod, Std = 4', ...
    'Wet, Std = 1', 'Wet, Std = 2', 'Wet, Std = 4', ...
    'Dry, Std = 1', 'Dry, Std = 2', 'Dry, Std = 4'};

for i=1:9
    subplot(3,3,i)
    imagesc(T_Precip_syn{i}(:,:,1));
    colorbar;
    %caxis([0 0.1]);
    xlabel('Precip State i')
    xticks([5:5:32]);
    yticks([5:5:32]);
    xticklabels([70:5:97]);
    yticklabels([70:5:97]);
    ylabel('Precip State i+1')
    axis square
    title(ScenName{i});
    set(gca, 'YDir', 'normal');
end

%% Save files w/ transition matrices

addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP');
load('T_Temp_Precip_RCP85A.mat', 'T_Temp');

T_Precip = T_Precip_syn{1};
save('T_Temp_Precip_mod1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{2};
save('T_Temp_Precip_mod2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{3};
save('T_Temp_Precip_mod4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{4};
save('T_Temp_Precip_wet1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{5};
save('T_Temp_Precip_wet2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{6};
save('T_Temp_Precip_wet4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{7};
save('T_Temp_Precip_dry1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{8};
save('T_Temp_Precip_dry2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{9};
save('T_Temp_Precip_dry4', 'T_Temp', 'T_Precip');

%% 5/29/2021- Create "drier" synthetic transition matrices w/ avg of 2 instead of 3 drier- 5/29

T_Precip_syn{1} = synthMatrix(-2, 1, 1); % dry, std = 1
T_Precip_syn{2} = synthMatrix(-2, 2, 1); % dry, std = 2
T_Precip_syn{3} = synthMatrix(-2, 4, 1); % dry, std = 4

addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP');
load('T_Temp_Precip_RCP85A.mat', 'T_Temp');

T_Precip = T_Precip_syn{1};
save('T_Temp_Precip_drier1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{2};
save('T_Temp_Precip_drier2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{3};
save('T_Temp_Precip_drier4', 'T_Temp', 'T_Precip');

%% 5/29/2021- Create "wetter" synthetic transition matrices w/ avg of 2 instead of 3 wetter- 5/30

T_Precip_syn{1} = synthMatrix(2, 1, 1); % wet, std = 1
T_Precip_syn{2} = synthMatrix(2, 2, 1); % wet, std = 2
T_Precip_syn{3} = synthMatrix(2, 4, 1); % wet, std = 4

addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP');
load('T_Temp_Precip_RCP85A.mat', 'T_Temp');

T_Precip = T_Precip_syn{1};
save('T_Temp_Precip_wetter1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{2};
save('T_Temp_Precip_wetter2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{3};
save('T_Temp_Precip_wetter4', 'T_Temp', 'T_Precip');

%% Create/Test TMs- 6/18/2021 (15_25_45)

% Get date for file name when saving results 
datetime=datestr(now);
datetime=strrep(datetime,':','_'); %Replace colon with underscore
datetime=strrep(datetime,'-','_');%Replace minus sign with underscore
datetime=strrep(datetime,' ','_');%Replace space with underscore

addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/Bayesian_Quant_Learning');
T_Precip_syn{1} = synthMatrix(0, 0.75, 1); % mod, std = 1
T_Precip_syn{2} = synthMatrix(0, 1.5, 1); % mod, std = 2
T_Precip_syn{3} = synthMatrix(0, 2.5, 1); % mod, std = 4

T_Precip_syn{4} = synthMatrix(2, 0.75, 1); % wet, std = 1
T_Precip_syn{5} = synthMatrix(2, 1.5, 1); % wet, std = 2
T_Precip_syn{6} = synthMatrix(2, 2.5, 1); % wet, std = 4

T_Precip_syn{7} = synthMatrix(-2, 0.75, 1); % dry, std = 1
T_Precip_syn{8} = synthMatrix(-2, 1.5, 1); % dry, std = 2
T_Precip_syn{9} = synthMatrix(-2, 2.5, 1); % dry, std = 4

cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP');
load('T_Temp_Precip_RCP85A.mat', 'T_Temp');

folderName = strcat('TMs_Test_', datetime)
mkdir(folderName);
cd(folderName);

T_Precip = T_Precip_syn{1};
save('T_Temp_Precip_mod1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{2};
save('T_Temp_Precip_mod2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{3};
save('T_Temp_Precip_mod4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{4};
save('T_Temp_Precip_wet1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{5};
save('T_Temp_Precip_wet2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{6};
save('T_Temp_Precip_wet4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{7};
save('T_Temp_Precip_dry1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{8};
save('T_Temp_Precip_dry2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{9};
save('T_Temp_Precip_dry4', 'T_Temp', 'T_Precip');

%% Create/Test TMs- V2 (test 3) (6/18/2021) (15_35_54) (20_Jun_2021_22_19_34)

% Get date for file name when saving results 
datetime=datestr(now);
datetime=strrep(datetime,':','_'); %Replace colon with underscore
datetime=strrep(datetime,'-','_');%Replace minus sign with underscore
datetime=strrep(datetime,' ','_');%Replace space with underscore

addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/Bayesian_Quant_Learning');
T_Precip_syn{1} = synthMatrix(0, 0.75, 1); % mod, std = 1
T_Precip_syn{2} = synthMatrix(0, 1.5, 1); % mod, std = 2
T_Precip_syn{3} = synthMatrix(0, 2.5, 1); % mod, std = 4

T_Precip_syn{4} = synthMatrix(1, 0.75, 1); % wet, std = 1
T_Precip_syn{5} = synthMatrix(1, 1.5, 1); % wet, std = 2
T_Precip_syn{6} = synthMatrix(1, 2.5, 1); % wet, std = 4

T_Precip_syn{7} = synthMatrix(-1, 0.75, 1); % dry, std = 1
T_Precip_syn{8} = synthMatrix(-1, 1.5, 1); % dry, std = 2
T_Precip_syn{9} = synthMatrix(-1, 2.5, 1); % dry, std = 4

cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP');
load('T_Temp_Precip_RCP85A.mat', 'T_Temp');

folderName = strcat('TMs_Test_', datetime)
mkdir(folderName);
cd(folderName);

T_Precip = T_Precip_syn{1};
save('T_Temp_Precip_mod1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{2};
save('T_Temp_Precip_mod2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{3};
save('T_Temp_Precip_mod4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{4};
save('T_Temp_Precip_wet1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{5};
save('T_Temp_Precip_wet2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{6};
save('T_Temp_Precip_wet4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{7};
save('T_Temp_Precip_dry1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{8};
save('T_Temp_Precip_dry2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{9};
save('T_Temp_Precip_dry4', 'T_Temp', 'T_Precip');


%% Create/Test TMs- V4 (6/18/2021) (16_08_19)
% Get date for file name when saving results 
datetime=datestr(now);
datetime=strrep(datetime,':','_'); %Replace colon with underscore
datetime=strrep(datetime,'-','_');%Replace minus sign with underscore
datetime=strrep(datetime,' ','_');%Replace space with underscore

addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/Bayesian_Quant_Learning');
T_Precip_syn{1} = synthMatrix_stateSpace(0, 0.75, 1); % mod, std = 1
T_Precip_syn{2} = synthMatrix_stateSpace(0, 1.5, 1); % mod, std = 2
T_Precip_syn{3} = synthMatrix_stateSpace(0, 2.5, 1); % mod, std = 4

T_Precip_syn{4} = synthMatrix_stateSpace(1, 0.75, 1); % wet, std = 1
T_Precip_syn{5} = synthMatrix_stateSpace(1, 1.5, 1); % wet, std = 2
T_Precip_syn{6} = synthMatrix_stateSpace(1, 2.5, 1); % wet, std = 4

T_Precip_syn{7} = synthMatrix_stateSpace(-1, 0.75, 1); % dry, std = 1
T_Precip_syn{8} = synthMatrix_stateSpace(-1, 1.5, 1); % dry, std = 2
T_Precip_syn{9} = synthMatrix_stateSpace(-1, 2.5, 1); % dry, std = 4

cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP');
load('T_Temp_Precip_RCP85A.mat', 'T_Temp');

folderName = strcat('TMs_Test_', datetime)
mkdir(folderName);
cd(folderName);

T_Precip = T_Precip_syn{1};
save('T_Temp_Precip_mod1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{2};
save('T_Temp_Precip_mod2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{3};
save('T_Temp_Precip_mod4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{4};
save('T_Temp_Precip_wet1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{5};
save('T_Temp_Precip_wet2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{6};
save('T_Temp_Precip_wet4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{7};
save('T_Temp_Precip_dry1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{8};
save('T_Temp_Precip_dry2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{9};
save('T_Temp_Precip_dry4', 'T_Temp', 'T_Precip');


%% Create/Test TMs- test 5 (6/18/2021) (16_39_37)
% ssd version b/c updated synthMatrix_stateSpace on 6/21
% Get date for file name when saving results 
datetime=datestr(now);
datetime=strrep(datetime,':','_'); %Replace colon with underscore
datetime=strrep(datetime,'-','_');%Replace minus sign with underscore
datetime=strrep(datetime,' ','_');%Replace space with underscore

addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/Bayesian_Quant_Learning');
T_Precip_syn{1} = synthMatrix_stateSpace(0, 1, 1); % mod, std = 1 
T_Precip_syn{2} = synthMatrix_stateSpace(0, 2, 1); % mod, std = 2
T_Precip_syn{3} = synthMatrix_stateSpace(0, 4, 1); % mod, std = 4

T_Precip_syn{4} = synthMatrix_stateSpace(2, 1, 1); % wet, std = 1
T_Precip_syn{5} = synthMatrix_stateSpace(2, 2, 1); % wet, std = 2
T_Precip_syn{6} = synthMatrix_stateSpace(2, 4, 1); % wet, std = 4

T_Precip_syn{7} = synthMatrix_stateSpace(-2, 1, 1); % dry, std = 1
T_Precip_syn{8} = synthMatrix_stateSpace(-2, 2, 1); % dry, std = 2
T_Precip_syn{9} = synthMatrix_stateSpace(-2, 4, 1); % dry, std = 4

cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP');
load('T_Temp_Precip_RCP85A.mat', 'T_Temp');

folderName = strcat('TMs_Test_', datetime)
mkdir(folderName);
cd(folderName);

T_Precip = T_Precip_syn{1};
save('T_Temp_Precip_mod1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{2};
save('T_Temp_Precip_mod2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{3};
save('T_Temp_Precip_mod4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{4};
save('T_Temp_Precip_wet1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{5};
save('T_Temp_Precip_wet2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{6};
save('T_Temp_Precip_wet4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{7};
save('T_Temp_Precip_dry1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{8};
save('T_Temp_Precip_dry2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{9};
save('T_Temp_Precip_dry4', 'T_Temp', 'T_Precip');


%% Create/Test TMs- test 4 (6/20/2021) (20_38_03)
% ssd version b/c updated synthMatrix_stateSpace on 6/21
% Get date for file name when saving results 
datetime=datestr(now);
datetime=strrep(datetime,':','_'); %Replace colon with underscore
datetime=strrep(datetime,'-','_');%Replace minus sign with underscore
datetime=strrep(datetime,' ','_');%Replace space with underscore

addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/Bayesian_Quant_Learning');
T_Precip_syn{1} = synthMatrix_stateSpace(0, 0.75, 1); % mod, std = 1
T_Precip_syn{2} = synthMatrix_stateSpace(0, 1.5, 1); % mod, std = 2
T_Precip_syn{3} = synthMatrix_stateSpace(0, 2.5, 1); % mod, std = 4

T_Precip_syn{4} = synthMatrix_stateSpace(2, 0.75, 1); % wet, std = 1
T_Precip_syn{5} = synthMatrix_stateSpace(2, 1.5, 1); % wet, std = 2
T_Precip_syn{6} = synthMatrix_stateSpace(2, 2.5, 1); % wet, std = 4

T_Precip_syn{7} = synthMatrix_stateSpace(-2, 0.75, 1); % dry, std = 1
T_Precip_syn{8} = synthMatrix_stateSpace(-2, 1.5, 1); % dry, std = 2
T_Precip_syn{9} = synthMatrix_stateSpace(-2, 2.5, 1); % dry, std = 4

cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP');
load('T_Temp_Precip_RCP85A.mat', 'T_Temp');

folderName = strcat('TMs_Test_', datetime)
mkdir(folderName);
cd(folderName);

T_Precip = T_Precip_syn{1};
save('T_Temp_Precip_mod1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{2};
save('T_Temp_Precip_mod2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{3};
save('T_Temp_Precip_mod4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{4};
save('T_Temp_Precip_wet1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{5};
save('T_Temp_Precip_wet2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{6};
save('T_Temp_Precip_wet4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{7};
save('T_Temp_Precip_dry1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{8};
save('T_Temp_Precip_dry2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{9};
save('T_Temp_Precip_dry4', 'T_Temp', 'T_Precip');

%% Create/Test TMs- test 2 (6/20/2021) (21_27_45)

% Get date for file name when saving results 
datetime=datestr(now);
datetime=strrep(datetime,':','_'); %Replace colon with underscore
datetime=strrep(datetime,'-','_');%Replace minus sign with underscore
datetime=strrep(datetime,' ','_');%Replace space with underscore

addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/Bayesian_Quant_Learning');
T_Precip_syn{1} = synthMatrix(0, 1, 1); % mod, std = 1
T_Precip_syn{2} = synthMatrix(0, 2, 1); % mod, std = 2
T_Precip_syn{3} = synthMatrix(0, 4, 1); % mod, std = 4

T_Precip_syn{4} = synthMatrix(2, 1, 1); % wet, std = 1
T_Precip_syn{5} = synthMatrix(2, 2, 1); % wet, std = 2
T_Precip_syn{6} = synthMatrix(2, 4, 1); % wet, std = 4

T_Precip_syn{7} = synthMatrix(-2, 1, 1); % dry, std = 1
T_Precip_syn{8} = synthMatrix(-2, 2, 1); % dry, std = 2
T_Precip_syn{9} = synthMatrix(-2, 4, 1); % dry, std = 4

cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP');
load('T_Temp_Precip_RCP85A.mat', 'T_Temp');

folderName = strcat('TMs_Test_', datetime)
mkdir(folderName);
cd(folderName);

T_Precip = T_Precip_syn{1};
save('T_Temp_Precip_mod1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{2};
save('T_Temp_Precip_mod2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{3};
save('T_Temp_Precip_mod4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{4};
save('T_Temp_Precip_wet1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{5};
save('T_Temp_Precip_wet2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{6};
save('T_Temp_Precip_wet4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{7};
save('T_Temp_Precip_dry1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{8};
save('T_Temp_Precip_dry2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{9};
save('T_Temp_Precip_dry4', 'T_Temp', 'T_Precip');

%% Create/Test TMs- Change over Time Test 6 (6/21/2021) (16_32_54)
% SSD- this version has a typo!!!!

% Get date for file name when saving results 
datetime=datestr(now);
datetime=strrep(datetime,':','_'); %Replace colon with underscore
datetime=strrep(datetime,'-','_');%Replace minus sign with underscore
datetime=strrep(datetime,' ','_');%Replace space with underscore

s_P_abs = 66:97;

addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/Bayesian_Quant_Learning');
T_Precip_syn{1} = synthMatrix_stateSpace(0, 3, 0.6, s_P_abs, 0); % mod, std = 1
T_Precip_syn{2} = synthMatrix_stateSpace(0, 3, 0.8, s_P_abs, 0); % mod, std = 2
T_Precip_syn{3} = synthMatrix_stateSpace(0, 3, 1, s_P_abs, 0); % mod, std = 4

T_Precip_syn{4} = synthMatrix_stateSpace(2, 3, 0.6, s_P_abs, 0); % wet, std = 1
T_Precip_syn{5} = synthMatrix_stateSpace(2, 3, 0.8, s_P_abs, 0); % wet, std = 2
T_Precip_syn{6} = synthMatrix_stateSpace(2, 3, 1, s_P_abs, 0); % wet, std = 4

T_Precip_syn{7} = synthMatrix_stateSpace(-2, 4, 0.6, s_P_abs, 0); % dry, std = 1
T_Precip_syn{8} = synthMatrix_stateSpace(-2, 4, 0.8, s_P_abs, 0); % dry, std = 2
T_Precip_syn{9} = synthMatrix_stateSpace(-2, 4, 1, s_P_abs, 0); % dry, std = 4

cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP');
load('T_Temp_Precip_RCP85A.mat', 'T_Temp');

folderName = strcat('TMs_Test_', datetime)
mkdir(folderName);
cd(folderName);

T_Precip = T_Precip_syn{1};
save('T_Temp_Precip_mod1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{2};
save('T_Temp_Precip_mod2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{3};
save('T_Temp_Precip_mod4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{4};
save('T_Temp_Precip_wet1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{5};
save('T_Temp_Precip_wet2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{6};
save('T_Temp_Precip_wet4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{7};
save('T_Temp_Precip_dry1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{8};
save('T_Temp_Precip_dry2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{9};
save('T_Temp_Precip_dry4', 'T_Temp', 'T_Precip');

%% Create/Test TMs- Change over Time Test 6 (6/22/2021) (16_02_34)

% Get date for file name when saving results 
datetime=datestr(now);
datetime=strrep(datetime,':','_'); %Replace colon with underscore
datetime=strrep(datetime,'-','_');%Replace minus sign with underscore
datetime=strrep(datetime,' ','_');%Replace space with underscore

s_P_abs = 66:97;

addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/Bayesian_Quant_Learning');
T_Precip_syn{1} = synthMatrix_stateSpace(0, 3, 0.6, s_P_abs, 0); % mod, std = 1
T_Precip_syn{2} = synthMatrix_stateSpace(0, 3, 0.8, s_P_abs, 0); % mod, std = 2
T_Precip_syn{3} = synthMatrix_stateSpace(0, 3, 1, s_P_abs, 0); % mod, std = 4

T_Precip_syn{4} = synthMatrix_stateSpace(2, 3, 0.6, s_P_abs, 0); % wet, std = 1
T_Precip_syn{5} = synthMatrix_stateSpace(2, 3, 0.8, s_P_abs, 0); % wet, std = 2
T_Precip_syn{6} = synthMatrix_stateSpace(2, 3, 1, s_P_abs, 0); % wet, std = 4

T_Precip_syn{7} = synthMatrix_stateSpace(-2, 3, 0.6, s_P_abs, 0); % dry, std = 1
T_Precip_syn{8} = synthMatrix_stateSpace(-2, 3, 0.8, s_P_abs, 0); % dry, std = 2
T_Precip_syn{9} = synthMatrix_stateSpace(-2, 3, 1, s_P_abs, 0); % dry, std = 4

cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP');
load('T_Temp_Precip_RCP85A.mat', 'T_Temp');

folderName = strcat('TMs_Test_', datetime)
mkdir(folderName);
cd(folderName);

T_Precip = T_Precip_syn{1};
save('T_Temp_Precip_mod1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{2};
save('T_Temp_Precip_mod2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{3};
save('T_Temp_Precip_mod4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{4};
save('T_Temp_Precip_wet1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{5};
save('T_Temp_Precip_wet2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{6};
save('T_Temp_Precip_wet4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{7};
save('T_Temp_Precip_dry1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{8};
save('T_Temp_Precip_dry2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{9};
save('T_Temp_Precip_dry4', 'T_Temp', 'T_Precip');


%% Testing- June 30, 2021 (2021_21_49_37)
% Get date for file name when saving results 
datetime=datestr(now);
datetime=strrep(datetime,':','_'); %Replace colon with underscore
datetime=strrep(datetime,'-','_');%Replace minus sign with underscore
datetime=strrep(datetime,' ','_');%Replace space with underscore

s_P_abs = 66:97;

addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/Bayesian_Quant_Learning');
T_Precip_syn{1} = synthMatrix_stateSpace(0, 4, 0.7, s_P_abs, 0); % mod, std = 1
T_Precip_syn{2} = synthMatrix_stateSpace(0, 4, 0.85, s_P_abs, 0); % mod, std = 2
T_Precip_syn{3} = synthMatrix_stateSpace(0, 4, 1, s_P_abs, 0); % mod, std = 4

T_Precip_syn{4} = synthMatrix_stateSpace(2, 4, 0.7, s_P_abs, 0); % wet, std = 1
T_Precip_syn{5} = synthMatrix_stateSpace(2, 4, 0.85, s_P_abs, 0); % wet, std = 2
T_Precip_syn{6} = synthMatrix_stateSpace(2, 4, 1, s_P_abs, 0); % wet, std = 4
 
T_Precip_syn{7} = synthMatrix_stateSpace(-2, 4, 0.7, s_P_abs, 0); % dry, std = 1
T_Precip_syn{8} = synthMatrix_stateSpace(-2, 4, 0.85, s_P_abs, 0); % dry, std = 2
T_Precip_syn{9} = synthMatrix_stateSpace(-2, 4, 1, s_P_abs, 0); % dry, std = 4

addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP');
load('T_Temp_Precip_RCP85A.mat', 'T_Temp');

folderName = strcat('TMs_Test_', datetime)
mkdir(folderName);
cd(folderName);

T_Precip = T_Precip_syn{1};
save('T_Temp_Precip_mod1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{2};
save('T_Temp_Precip_mod2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{3};
save('T_Temp_Precip_mod4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{4};
save('T_Temp_Precip_wet1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{5};
save('T_Temp_Precip_wet2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{6};
save('T_Temp_Precip_wet4', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{7};
save('T_Temp_Precip_dry1', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{8};
save('T_Temp_Precip_dry2', 'T_Temp', 'T_Precip');

T_Precip = T_Precip_syn{9};
save('T_Temp_Precip_dry4', 'T_Temp', 'T_Precip');

T_Precip_high = synthMatrix_stateSpace([-2 0 2], 4, .7, 66:97, 0);
T_Precip = T_Precip_high;
save('T_Temp_Precip_high', 'T_Precip', 'T_Temp');

T_Precip_medium = synthMatrix_stateSpace([-2 0 2], 4, .85, 66:97, 0);
T_Precip = T_Precip_medium;
save('T_Temp_Precip_medium', 'T_Precip', 'T_Temp');

T_Precip_low = synthMatrix_stateSpace([-2 0 2], 4, 1, 66:97, 0);
T_Precip = T_Precip_low;
save('T_Temp_Precip_low', 'T_Precip', 'T_Temp');