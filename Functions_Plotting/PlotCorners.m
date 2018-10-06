function [  ] = PlotCorners(Corners);%,TestPt,LosBeaconIndex,MeasuredRanges)

%Nb = size(BeaconPos,1);
Corners = [Corners; Corners(1,:)];

%figure;
plot(Corners(:,1),Corners(:,2),'color',[0.5 0.5 0.5],'linewidth',2);
LabelSize = 18;
hold on;scatter(Corners(:,1),Corners(:,2),50,'MarkerEdgeColor','b','MarkerFaceColor',[0 0 0.2],'LineWidth',2);
        
%axis tight;
xlim([min(Corners(:,1))-0.5 max(Corners(:,1))+0.5]);
ylim([min(Corners(:,2))-0.5 max(Corners(:,2))+0.5]);

axis equal;
xlabel('x (m)','FontSize',LabelSize);
ylabel('y (m)','FontSize',LabelSize);
set(gca,'fontsize',LabelSize);
grid on;

end

