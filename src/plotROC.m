function plotROC(LRs, labels)

figure_title = 'ROC Plot, Threshold at LR = 1';

[X,Y,T,AUC,OPTROCPT] = perfcurve(labels, LRs, 1, 'TVals', 1.0, 'nboot', 1000);
figure; errorbar(X,Y(:,1),Y(:,2)-Y(:,1),Y(:,3)-Y(:,1)); 

figure; plot(X,Y)
% new figure calle dinside function, so we can avoid handles figures of LR_GUI
plot(X, Y, 'Color', 'r', 'LineStyle', '-');

title(figure_title)
xlabel('False Possitive Rate')
ylabel('True Positive Rate')

return

