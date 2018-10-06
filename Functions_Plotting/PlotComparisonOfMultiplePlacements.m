function [  ] = PlotComparisonOfMultiplePlacements(FloorPlanPath,BeacPlacementName)

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingClusters.mat'));

PlacementTypes=[];
if exist(fullfile(FloorPlanPath,'D2','FinalPlacementAndQuality.mat'))
    PlacementTypes=[PlacementTypes,'U'];
end
if exist(fullfile(FloorPlanPath,'D3','FinalPlacementAndQuality.mat'))
    PlacementTypes=[PlacementTypes,'D'];
end
if exist(fullfile(FloorPlanPath,'D1','FinalPlacementAndQuality.mat'))
    PlacementTypes=[PlacementTypes,'C'];
end
if exist(fullfile(FloorPlanPath,'D4','FinalPlacementAndQuality.mat'))
    PlacementTypes=[PlacementTypes,'E'];
end
if exist(fullfile(FloorPlanPath,'D5','FinalPlacementAndQuality.mat'))
    PlacementTypes=[PlacementTypes,'S'];
end
figure;

legendName = cell(0,0);
DOP_UL_DataAll = [];
NumTypes = size(PlacementTypes,2);
for i = 1:NumTypes
    switch PlacementTypes(i)
        case 'U'
            load(fullfile(FloorPlanPath,'D2','FinalPlacementAndQuality.mat'));
            PlacementLegend = ['UL mode (',num2str(length(FinalPlacementAndQuality{1})),' beacons)'];
            PlacementTitle = ['UL mode'];
        case 'D'
            load(fullfile(FloorPlanPath,'D3','FinalPlacementAndQuality.mat'));
            PlacementLegend = ['GDOP mode (',num2str(length(FinalPlacementAndQuality{1})),' beacons)'];
            PlacementTitle = ['GDOP mode'];

        case 'C' % custom
            load(fullfile(FloorPlanPath,'D1','FinalPlacementAndQuality.mat'));
            PlacementLegend = ['Custom (',num2str(length(FinalPlacementAndQuality{1})),' beacons)'];
            PlacementTitle = ['Custom'];

         case 'E' % e-net
            load(fullfile(FloorPlanPath,'D4','FinalPlacementAndQuality.mat'));
            PlacementLegend = ['Enet (',num2str(length(FinalPlacementAndQuality{1})),' beacons)'];
            PlacementTitle = ['Enet'];
            
         case 'S' % Submodular
            load(fullfile(FloorPlanPath,'D5','FinalPlacementAndQuality.mat'));
            PlacementLegend = ['Submodular (',num2str(length(FinalPlacementAndQuality{1})),' beacons)'];
            PlacementTitle = ['Submodular'];
    end    

    BeaconInd = FinalPlacementAndQuality{1};
    Class = FinalPlacementAndQuality{2};
    DOP_UL = FinalPlacementAndQuality{4};
    BeaconPos = AllCornerObsPos(BeaconInd,:);
    legendName = [legendName; PlacementLegend];
    DOP_UL_DataAll = [DOP_UL_DataAll DOP_UL];

    subplot(2,NumTypes,i),PlotCoverageClass( BeaconPos,Class,FloorPlanPath,1,0 );
    title(PlacementTitle);
    if i==1 ylabel('Coverage'); end
    subplot(2,NumTypes,i+NumTypes),PlotDOPforBeaconPlacement( BeaconPos,DOP_UL,FloorPlanPath,0 );
    if i==1 ylabel('GDOP'); end
end

     %       [ax1,h1]=suplabel('super X label');
     %       [ax2,h2]=suplabel('super Y label','y');
     %       [ax3,h2]=suplabel('super Y label (right)','yy');
            [ax4,h3]=suplabel('Comparison of different placements'  ,'t');

PlotMultipleCdfDop(DOP_UL_DataAll,legendName);






