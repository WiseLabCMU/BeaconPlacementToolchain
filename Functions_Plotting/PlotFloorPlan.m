function [  ] = PlotFloorPlan(FloorPlanPath,F_NewFig,F_AddnBeac)%,TestPt,LosBeaconIndex,MeasuredRanges)

F_TickOff=0;
LabelSize=18;

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
%load(fullfile(FloorPlanPath,'Corners.mat'));
%load(fullfile(FloorPlanPath,'Obstacles.mat'));

if F_NewFig
    figure;
end
plot(Corners(:,1),Corners(:,2),'color',[0.5 0.5 0.5],'linewidth',2);hold on;
for m = 1:size(Obstacles,2)
    obs = Obstacles{m};
    if(~isempty(obs))
    fill(obs(:,1),obs(:,2),[0.8 0.8 0.8]);
    end
end
% = 18;
%axis tight;
xlim([min(Corners(:,1))-0.4 max(Corners(:,1))+0.4]);
ylim([min(Corners(:,2))-0.4 max(Corners(:,2))+0.4]);
axis equal;

if F_TickOff==1
    set(gca,'XTickLabel','');
    set(gca,'YTickLabel','');
else
    xlabel('x (m)','FontSize',LabelSize);
    ylabel('y (m)','FontSize',LabelSize);

end

set(gca,'fontsize',LabelSize);
grid on;

if exist('AddnPotentialBeacLoc')==1
if F_AddnBeac && ~isempty(AddnPotentialBeacLoc)
    scatter(AddnPotentialBeacLoc(:,1),AddnPotentialBeacLoc(:,2),100,'r*');
end
end

if exist('SelectCornersForBeacLoc')==1
if F_AddnBeac && ~isempty(SelectCornersForBeacLoc)
    scatter(SelectCornersForBeacLoc(:,1),SelectCornersForBeacLoc(:,2),100,'r*');
end
end


end

