function [] =  PlotDOPforBeaconPlacement(BeaconPos,DOP,FloorPlanPath,F_NewFig)

MAXDOP = 8;

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));

%PlotFloorPlan(FloorPlanPath,F_NewFig);
%scatter(BeaconPos(:,1),BeaconPos(:,2),250,'MarkerEdgeColor',[0.5 0 0],'MarkerFaceColor','r','LineWidth',2);

Corners = [Corners; Corners(1,:)];

% Create a grid and fill up the PtsInFp points with their DOP values
xMin = min(Corners(:,1))-GridSize/2;
xMax = max(Corners(:,1))+GridSize/2;
yMin = min(Corners(:,2))-GridSize/2;
yMax = max(Corners(:,2))+GridSize/2;

[AllPtsInGridX,AllPtsInGridY]=meshgrid(xMin:GridSize:xMax,yMin:GridSize:yMax);

AllPtsInGrid = [reshape(AllPtsInGridX,size(AllPtsInGridX,1)*size(AllPtsInGridX,2),1)...
reshape(AllPtsInGridY,size(AllPtsInGridY,1)*size(AllPtsInGridY,2),1)];

DOPgrid = nan*ones(size(AllPtsInGridX,1),size(AllPtsInGridX,2));
DOParray = reshape(DOPgrid,size(DOPgrid,1)*size(DOPgrid,2),1);
[MatchVal,MatchInd]=intersect(AllPtsInGrid,PtsInFp,'rows');
%DOParray2=DOParray;
DOParray(MatchInd)=DOP;%min(10,DOP);
IndNotNan = ~isnan(DOParray);

%DOParray(IndNotNan) = log(DOParray(IndNotNan));
%DOParray(IndNotNan) = min(MAXDOP,DOParray(IndNotNan));
DOParray(IndNotNan) = DOParray(IndNotNan);

DOPgrid = reshape(DOParray,size(DOPgrid,1),size(DOPgrid,2));
pcolor(AllPtsInGridX-GridSize/2,AllPtsInGridY-GridSize/2,DOPgrid);

hold on;
plot(Corners(:,1),Corners(:,2),'color',[0.5 0.5 0.5],'linewidth',2);
LabelSize = 12;

%colorbar;

%caxis([0 3]);

caxis([0 MAXDOP]);
axis tight;
axis equal;
%legend(LegendDesc,'Location','NorthWest');
%xlabel('x (m)','FontSize',LabelSize);
%ylabel('y (m)','FontSize',LabelSize);
set(gca,'fontsize',LabelSize);
shading flat
PlotFloorPlan(FloorPlanPath,0,1);

grid on;

scatter(BeaconPos(:,1),BeaconPos(:,2),200,'MarkerEdgeColor',[0.3 0.3 0.3],'MarkerFaceColor','k','LineWidth',1);
%scatter(BeaconPos(:,1),BeaconPos(:,2),200,'MarkerEdgeColor','r','MarkerFaceColor','k','LineWidth',1);





