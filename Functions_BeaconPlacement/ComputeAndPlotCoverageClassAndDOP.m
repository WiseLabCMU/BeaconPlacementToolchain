function [ ] = ComputeAndPlotCoverageClassAndDOP(FloorPlanPath,BeacPlacementName,LengendText)
% BeacPlacementDir can be 'BeacPlacement_D', 'BeacPlacement_U' or
% 'BeacPlacement_Custom'

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingInfo.mat'));

load(fullfile(FloorPlanPath,BeacPlacementName,'BeaconPlaceInd.mat'),'BeaconPlaceInd');

BeaconPos = AllCornerObsPos(BeaconPlaceInd,:);
BeaconCoverage = RayTracingInfoCornerObs(BeaconPlaceInd);
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

save(fullfile(FloorPlanPath,BeacPlacementName,'FinalPlacementAndQuality.mat'),'FinalPlacementAndQuality');



end

