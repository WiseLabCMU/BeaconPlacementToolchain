function [  ] = PlotRayTracingAllCorners(FloorPlanPath)%,TestPt,LosBeaconIndex,MeasuredRanges)

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingInfo.mat'));

PlotFloorPlan(FloorPlanPath,1,1);
scatter(PtsInFp(:,1),PtsInFp(:,2));

for i = 1:size(RayTracingInfoCornerObs,1);
    PlotFloorPlan(FloorPlanPath,1,1);
    scatter(PtsInFp(RayTracingInfoCornerObs{i},1),PtsInFp(RayTracingInfoCornerObs{i},2));
    scatter(AllCornerObsPos(i,1),AllCornerObsPos(i,2),150,'filled');
end


end

