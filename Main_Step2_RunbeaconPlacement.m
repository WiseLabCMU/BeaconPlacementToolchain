clc; clear; close all;
load RootPath.mat;
rng('default')
figure;F_NewFig=0;F_AddnBeac=1;
RepoNames = dir(fullfile(RootPath,'FloorPlanPaths','F*'));
for n = 1:numel(RepoNames)
    DisplayFloorPlanPath = fullfile(RootPath,'FloorPlanPaths',RepoNames(n).name);
    subplot(3,ceil(numel(RepoNames)/3),n);
    PlotFloorPlan(DisplayFloorPlanPath,F_NewFig,F_AddnBeac);                
    title([RepoNames(n).name]);
end

SelectFP = -1; Flag=0;
while (SelectFP==0 || ~Flag)
    SelectFP = input(['Select floor plan : F']);
    Flag = exist(fullfile(RootPath,'FloorPlanPaths',['F',num2str(SelectFP)]));
end

if Flag~=0 % floor plan selected
    FloorPlanPath = fullfile(RootPath,'FloorPlanPaths',['F',num2str(SelectFP)]);
    BeacPlacementType = -1;
    while (BeacPlacementType<0 || BeacPlacementType>5)
        BeacPlacementType = input(['1: Custom Placement \n2: UL algorithm \n3: GDOP algorithm \n4: e-net algorithm \n5: Submod algorithm\nEnter choice: ']);
    end
end

if ~exist(fullfile(FloorPlanPath,'RayTracing')) % Ray tracing not performed
    mkdir(fullfile(FloorPlanPath,'RayTracing'));
    MainRayTracing(FloorPlanPath);
end

BeacPlacementName = ['D',num2str(BeacPlacementType)];
if exist(fullfile(FloorPlanPath,BeacPlacementName)) % Ray tracing not performed
    rmdir(fullfile(FloorPlanPath,BeacPlacementName),'s');
end
mkdir(fullfile(FloorPlanPath,BeacPlacementName));

switch BeacPlacementType
    case 1 % User defined
        Call_UserDefinedBeaconPlacement(FloorPlanPath,BeacPlacementName);
        
    case 2 % UL algorithm
        Call_BeaconPlacement(FloorPlanPath,BeacPlacementName);
        
    case 3 % GDOP algorithm
        Call_BeaconPlacement(FloorPlanPath,BeacPlacementName);

    case 4 % e-net algorithm
        Call_BeaconPlacement_enet(FloorPlanPath, BeacPlacementName);
        
    case 5 % greedy submod
        Call_BeaconPlacement_submod(FloorPlanPath, BeacPlacementName);
end

PlotDeployment(FloorPlanPath,BeacPlacementName);
if BeacPlacementType==2 || BeacPlacementType==3
    PlotBeacPlacementSteps(FloorPlanPath,BeacPlacementName);
end
%     FloorPlan_Path = fullfile(RootPath,'FloorPlanPaths',NameFP);

PlotComparisonOfMultiplePlacements(FloorPlanPath);

%Call_UserDefinedBeaconPlacement(SelectedBeaconPlacement_Path);
%ComputeAndPlotCoverageClassAndDOP(SelectedBeaconPlacement_Path,'CDF');
%PlotComparisonOfMultiplePlacements();
