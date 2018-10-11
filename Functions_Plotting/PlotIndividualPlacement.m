function [  ] = PlotIndividualPlacement(FloorPlanPath,PlacementType)

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingClusters.mat'));

load(fullfile(FloorPlanPath,['D',num2str(PlacementType)],'FinalPlacementAndQuality.mat'));

BeaconInd = FinalPlacementAndQuality{1};
Class = FinalPlacementAndQuality{2};
DOP_UL = FinalPlacementAndQuality{4};
BeaconPos = AllCornerObsPos(BeaconInd,:);


PlotCoverageClass( BeaconPos,Class,FloorPlanPath,2,1 );
    





