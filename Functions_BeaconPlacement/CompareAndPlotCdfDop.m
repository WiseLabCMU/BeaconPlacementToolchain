function [ Area] = CompareAndPlotCdfDop( Data,F_plot )

F_PlotULAreaLine=1;

MAXDOP = 8;
legendName = cell(0,0);
arrayMarker = {'*','v','o','s','d','+'};
arrayLineType = {'--','-.',':','-'};
col = hsv(size(Data,2));%rand(8,3);

for s=1:size(Data,2)
    DataSorted(:,s)=sort(Data(:,s),'ascend');
    %DataSorted(find(DataSorted(:,s)>MAXDOP),s) = MAXDOP;
end

% For finding area under CDF
d = 0:0.2:MAXDOP;
Area = zeros(length(d),size(DataSorted,2));
if F_plot 
    figure;hold on;
end
for i = 1:size(DataSorted,2)
    L = length(DataSorted(:,i));
    for t = 1:length(d)
        Area(t,i) = length(find(DataSorted(:,i)<d(t)))/L*100;
    end
    if F_plot
        plot(d,Area(:,i),[arrayLineType{mod(i,length(arrayLineType)-1)+1}],'color',col(i,:),'linewidth',8);
        legendName = [legendName; ['Configuration ',num2str(i)]];
    end;
    LocalizableArea(i) = length(find(~isnan(DataSorted(:,i))))/length(DataSorted(:,i))*100;

end

if F_plot
    
    if(F_PlotULAreaLine)
        for i = 1:size(DataSorted,2)
            plot([0 MAXDOP],[LocalizableArea(i) LocalizableArea(i)],[arrayLineType{mod(i,length(arrayLineType)-1)+1}],'color',col(i,:),'linewidth',2);
        end
    end
    set(gca,'FontSize',18);
    grid on;
    xlabel('GDOP');
    ylabel('Percentage of area in floor plan (%)');
    legend(legendName,'Location','SouthEast','FontSize',24);
    xlim([0 MAXDOP]);
end

sum(Area)
[~,MaxInd]=max(sum(Area));
end

