function [] = PlotDeployment(FloorPlanPath,BeacPlacementName)

load(fullfile(FloorPlanPath,BeacPlacementName,'BeaconPlaceInd.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));

F_NewFig=1; F_AddnBeac=1;
PlotFloorPlan(FloorPlanPath,F_NewFig,F_AddnBeac)%,TestPt,LosBeaconIndex,MeasuredRanges)
scatter(AllCornerObsPos(BeaconPlaceInd,1),AllCornerObsPos(BeaconPlaceInd,2),60,'filled','r');

end

