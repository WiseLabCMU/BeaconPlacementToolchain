function [Corners,Obstacles] = Call_PreDefinedFloorPlan()
% User defines a floor plan by placing cursor on corners

Corners=[]; Obstacles = [];
%clc; clear; close all;
load RootPath.mat;
figure;
for n = 1:10
    DisplayFloorPlanPath = fullfile(RootPath,'TemplateFloorPlans',['Template',num2str(n)]);
    subplot(2,5,n);F_NewFig=0;
    PlotFloorPlan(DisplayFloorPlanPath,F_NewFig);                
    title(['Floor Plan ',num2str(n)]);
end
SelectFP = -1;
while (SelectFP<0 || SelectFP>10)
    SelectFP = input(['Select floor plan 1-10: ']);
end
if SelectFP~=0
            
%     FloorPlan_Path = fullfile(RootPath,'FloorPlanPaths',NameFP);

    Template_Path = fullfile(RootPath,'TemplateFloorPlans',['Template',num2str(SelectFP)]);
    load(fullfile(Template_Path,'Corners.mat'));
    load(fullfile(Template_Path,'Obstacles.mat'));
%     if exist(FloorPlan_Path)
%         rmdir(FloorPlan_Path,'s');
%     end
%     mkdir(FloorPlan_Path);
    Scale = -1;
    while (Scale<=0 || Scale>10)
        Scale = input(['Scale (typically 1) = ']);
    end
    Corners = Corners*Scale;
    if ~isempty(Obstacles)
        Obstacles = cellfun(@(x) x*Scale,Obstacles,'un',0);
    end
%     save(fullfile(FloorPlan_Path,'Corners.mat'),'Corners');
%     save(fullfile(FloorPlan_Path,'Obstacles.mat'),'Obstacles');
%     [AddnPotentialBeacLoc] =  Generate_AddnPotentialBeacLoc(FloorPlan_Path);
%     save(fullfile(FloorPlan_Path,'AddnPotentialBeacLoc.mat'),'AddnPotentialBeacLoc');
end
