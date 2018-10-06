function [  ] = PlotCoverageClass( BeaconPos,Class,FloorPlanPath,F_color,F_NewFig )

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));

PlotFloorPlan(FloorPlanPath,F_NewFig,1);
%scatter(BeaconPos(:,1),BeaconPos(:,2),250,'MarkerEdgeColor',[0.5 0 0],'MarkerFaceColor','r','LineWidth',2);

if F_color==1
C = find(Class==1);
scatter(PtsInFp(C,1),PtsInFp(C,2),'g*');
C = find(Class==2);
scatter(PtsInFp(C,1),PtsInFp(C,2),'b*');
C = find(Class==3);
scatter(PtsInFp(C,1),PtsInFp(C,2),'c*');
C = find(Class==4);
scatter(PtsInFp(C,1),PtsInFp(C,2),'m*');
C = find(Class==5);
scatter(PtsInFp(C,1),PtsInFp(C,2),'y*');
C = find(Class==6);
scatter(PtsInFp(C,1),PtsInFp(C,2),'r*');
else
C = find(Class==1 | Class==2 | Class==3);
scatter(PtsInFp(C,1),PtsInFp(C,2),'k*');
end
PlotFloorPlan(FloorPlanPath,0,1);

scatter(BeaconPos(:,1),BeaconPos(:,2),200,'MarkerEdgeColor',[0.3 0.3 0.3],'MarkerFaceColor','k','LineWidth',1);

end

