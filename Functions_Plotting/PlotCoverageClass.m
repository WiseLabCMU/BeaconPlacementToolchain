function [  ] = PlotCoverageClass( BeaconPos,Class,FloorPlanPath,F_color,F_NewFig )

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));

PlotFloorPlan(FloorPlanPath,F_NewFig,1);
%PlotDeployment(FloorPlanPath,F_NewFig,1);
%scatter(BeaconPos(:,1),BeaconPos(:,2),250,'MarkerEdgeColor',[0.5 0 0],'MarkerFaceColor','r','LineWidth',2);

switch F_color
    case 0 % Plot UL or not UL in different colors
        C = find(Class==1 | Class==2 | Class==3);
        scatter(PtsInFp(C,1),PtsInFp(C,2),'k*');
    case 1 % plot all classes in in different colors
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
    case 2 % Plot 2-beacon coverage and 3 beacon coverage in different colors
        C = find(Class==3);
        scatter(PtsInFp(C,1),PtsInFp(C,2),'*','MarkerEdgeColor',[0.3 0.3 0.3]);      
end
PlotFloorPlan(FloorPlanPath,0,1);
%PlotDeployment(FloorPlanPath,0,1);

%scatter(BeaconPos(:,1),BeaconPos(:,2),200,'MarkerEdgeColor',[0.3 0.3 0.3],'MarkerFaceColor','k','LineWidth',1);
scatter(BeaconPos(:,1),BeaconPos(:,2),200,'MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',1);

end

