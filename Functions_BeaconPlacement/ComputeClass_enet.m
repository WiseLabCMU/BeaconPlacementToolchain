% Haotian Modifer the function definition. Add the input parameter and
% output parameter. Now you have already choose some beacons.
% flag: whether these beacons can unique localize the whole region
% NonCoverBeacon: If these beacons cannot unique localize, we find a
% subregion with ambiguity. NonCoverBeacon contains all the beacons can see
% this subregion.
function [flag, NonCoverBeacon ] = ComputeClass_enet(FloorPlanPath,BeacPlacementName,LengendText, Process) %Modified
% BeacPlacementDir can be 'BeacPlacement_D', 'BeacPlacement_U' or
% 'BeacPlacement_Custom'
load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingClusters.mat'));
load(fullfile(FloorPlanPath,BeacPlacementName,'BeaconPlaceInd.mat'));

% load RootPath.mat; load CurrentFloorPlan.mat;
% FloorPlan_Path = fullfile(RootPath,'FloorPlanPaths',CurrentFloorPlan);
% 
% load(fullfile(FloorPlan_Path,'Corners.mat'));
% load(fullfile(FloorPlan_Path,'Obstacles.mat'));
% load(fullfile(FloorPlan_Path,'FloorPlanPtsInfo.mat'));
% load(fullfile(FloorPlan_Path,'RayTracingInfo.mat'));
% 
% load(fullfile(BeacPlacementDir,'BeaconPlaceInd.mat'),'BeaconPlaceInd');

BeaconPos = AllCornerObsPos(BeaconPlaceInd,:);
BeaconCoverage = RayTracingInfoCornerObs(BeaconPlaceInd,:);
PtsInFp_LosBeac = cell(size(PtsInFp,1),2);
for nB = 1:length(BeaconPlaceInd)
    PtsInLos = PtsInFp(BeaconCoverage{nB},:);
    IndexPtsInLos = find(ismember(PtsInFp,PtsInLos,'rows'));
    for k = 1:length(IndexPtsInLos)
        PtsInFp_LosBeac{IndexPtsInLos(k),2}=[PtsInFp_LosBeac{IndexPtsInLos(k),2} BeaconPlaceInd(nB)];
    end
end

for k = 1:size(PtsInFp,1)
    PtsInFp_LosBeac{k,1}=size(PtsInFp_LosBeac{k,2},2);
end
                
Class=GetClassOfPoints(PtsInFp_LosBeac,BeaconPos,FloorPlanPath);

% Haotian Modified Part Begin:
% In this part, we detect whether these beacon can unique localize the
% whole region. If not, we will find some beacon locations and return to
% double their weight.

% BeaconPlaceIndex: Index of all the potential beacon locations.
BeaconPlaceIndex = 1:size(AllCornerObsPos,1);
% According to all the potential beacon locations, calculate the
% subregions.
CornerCoverage = RayTracingInfoCornerObs(BeaconPlaceIndex,:);

% If there is a subregion has ambiguity, we do the following process. 
if find(Class>3)
    % Find all the points that have ambiguity.
    Points = find(Class>3);
    
    % Choose random one of these points.
    rand('state',sum(100*clock));
    Point = PtsInFp(Points(1+fix(rand()*size(Points,1))),:);
    %display(Point);
    
    % Compute the beacons which can see this point.
    NonCoverBeacon = [];
    for i = 1:size(AllCornerObsPos,1)
        PtsLos = PtsInFp(CornerCoverage{i},:);
        if (ismember(Point, PtsLos, 'rows'))
            NonCoverBeacon = [NonCoverBeacon, i];
        end
    end
    % Set value of flag, which means these beacons cannot unique localize
    % the whole region.
    flag = 1;
    % Return back.
    return
end
% If these beacons can unique localize the whole region, set value of flag
% and NonCoverBeacon. When Process = 1, it means we are still in the
% finding better solution process and we do not need to output the figure
% result. When Process = 0. we need to output the final result.
flag = 0;
if (Process == 1)
    flag = 0;
    NonCoverBeacon = [];
    return;
end
%Haotian Modified Part End.

[DOP,DOP_UL]=GetDopOfPoints(PtsInFp_LosBeac,Class,FloorPlanPath);

figure;subplot(1,2,1);
F_color=1;
PlotCoverageClass( BeaconPos,Class,FloorPlanPath,1,0 );
title('Coverage class');
subplot(1,2,2);PlotDOPforBeaconPlacement(BeaconPos,DOP_UL,FloorPlanPath,0);
%hsp1 = get(gca, 'Position') 
title('DOP');
FinalPlacementAndQuality = {BeaconPlaceInd Class DOP DOP_UL};
%FinalPlacementAndQuality(1) = {cell2mat(StoreClassDOPAll(:,1))}; %Store the ind of all beacons
%save(fullfile(ResultPath,'FinalPlacementAndQuality.mat'),'FinalPlacementAndQuality');

save(fullfile(fullfile(FloorPlanPath,BeacPlacementName),'FinalPlacementAndQuality.mat'),'FinalPlacementAndQuality');

flag = 0;
NonCoverBeacon = [];

end

