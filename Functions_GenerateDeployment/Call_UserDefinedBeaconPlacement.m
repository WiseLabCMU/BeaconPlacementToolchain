function Call_UserDefinedBeaconPlacement(FloorPlanPath,BeacPlacementName)
% User defines a floor plan by placing cursor on corners

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingInfo.mat'));

F_NewFig=1;
PlotFloorPlan(FloorPlanPath,F_NewFig,0);

xlim([min(Corners(:,1))-0.5 max(Corners(:,1))+0.5]);
ylim([min(Corners(:,2))-0.5 max(Corners(:,2))+0.5]);
scatter(AllCornerObsPos(:,1),AllCornerObsPos(:,2),60,'g','filled');
title('Beacon Placement: Click on potential beacon locations. Press space when done.');
set(gca,'FontSize',14);

[x,y,button] = ginput(1);
scatter(x,y,100,'rx');hold on;
DistToCorners = pdist2([x y],AllCornerObsPos);
[minval,minindx]=min(DistToCorners);
ClosestCorner = AllCornerObsPos(minindx,:);
scatter(ClosestCorner(1),ClosestCorner(2),200,'MarkerEdgeColor',[0.5 0 0],'MarkerFaceColor','r','LineWidth',2);hold on;

set(gca,'FontSize',14);

CursorPts = ClosestCorner;
NumPts = 1;
BeaconPlaceInd=[minindx];
while button ~=32 % until space key is pressed
    [x,y,button] = ginput(1);
    scatter(x,y,100,'rx');hold on;
    DistToCorners = pdist2([x y],AllCornerObsPos);
    [minval,minindx]=min(DistToCorners);
    ClosestCorner = AllCornerObsPos(minindx,:);
    scatter(ClosestCorner(1),ClosestCorner(2),200,'MarkerEdgeColor',[0.5 0 0],'MarkerFaceColor','r','LineWidth',2);hold on;
    %CursorPts = [CursorPts; ClosestCorner];
    BeaconPlaceInd = [BeaconPlaceInd; minindx];
end
BeaconPlaceInd(end) = [];

save(fullfile(FloorPlanPath,BeacPlacementName,'BeaconPlaceInd.mat'),'BeaconPlaceInd')
ComputeAndPlotCoverageClassAndDOP(FloorPlanPath,BeacPlacementName,'CDF');
% Last point is the Space from keyboard - remove it
%CursorPts = CursorPts(1:end-1,:);
%NumPts = NumPts-1;

%BeaconPos = CursorPts;
%[~,BeaconInd]=ismember(BeaconPos,AllCornerObsPos,'rows');
%save(fullfile(FloorPlanPath,'BeacPlacement_Custom','BeaconInd.mat'),'BeaconInd');

