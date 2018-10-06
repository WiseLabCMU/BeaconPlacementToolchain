function [ ] = PlotMultipleCdfDop( Data,LengendText )

F_PlotULAreaLine=1;

MAXDOP = 8;
legendName = cell(0,0);
arrayMarker = {'*','v','o','s','d','+'};
arrayLineType = {'--','-.',':','-'};
col = hsv(size(Data,2));%rand(8,3);

for s=1:size(Data,2)
    DataSorted(:,s)=sort(Data(:,s),'ascend');
end

% For finding area under CDF
d = 0:0.2:MAXDOP;
Area = zeros(length(d),size(DataSorted,2));
figure;
hold on;

for i = 1:size(DataSorted,2)
    L = length(DataSorted);
    for t = 1:length(d)
        Area(t,i) = length(find(DataSorted(:,i)<d(t)))/L*100;
    end
    plot(d,Area(:,i),'color',col(i,:),'linewidth',6);
    %legendName = 'CDF';
    LocalizableArea(i) = length(find(~isnan(DataSorted(:,i))))/length(DataSorted(:,i))*100;
    %legend(legendName,'Location','SouthEast','FontSize',24);
end
    set(gca,'FontSize',18);
    for i = 1:size(DataSorted,2)
        if(F_PlotULAreaLine)
            plot([0 MAXDOP*0.6],[LocalizableArea(i) LocalizableArea(i)],'color',col(i,:),'linewidth',2);
        end
    end
    legend(LengendText,'location','southeast');

    grid on;
    xlabel('Error (m)');
    ylabel('Percentage of area in floor plan (%)');
    xlim([0 MAXDOP*0.6]);
    title('Accuracy expected');

%sum(Area);
%[~,MaxInd]=max(sum(Area));
end

