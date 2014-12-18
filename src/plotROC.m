function plotROC(LRs, labels)

[X,Y,T] = perfcurve(labels, LRs, 1, 'TVals',[linspace(0.01, 0.95, 500) ,1.0, linspace(1.05, 100, 500)]);
figure; plot(X,Y)
% new figure calle dinside function, so we can avoid handles figures of LR_GUI
plot(X, Y, 'Color', 'r', 'LineStyle', '-');
figure_title = ['ROC Plot, Thresholds from LR [', num2str(T(end)),' to ', num2str(T(1)), ']'];

title(figure_title)
xlabel('False Possitive Rate')
ylabel('True Positive Rate')

return

