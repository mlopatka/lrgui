function plotTippet(LR_same, LR_diff) 

figure_title = 'Tippett Plot';
LINE_STYLE = '-';

LR_diff = log(LR_diff(:));
LR_diffSrcSorted = sort(LR_diff);
num_diffSrc_comparisons = numel(LR_diff);
cumPrDiffLRs = (num_diffSrc_comparisons:-1:1)/num_diffSrc_comparisons;

LR_same = log(LR_same(:));
LR_sameSrcSorted = sort(LR_same);
num_sameSrc_comparisons = numel(LR_same);
cumPrSameLRs = (1:num_sameSrc_comparisons)/num_sameSrc_comparisons;

figure('name','Tippett plot'); % new figure calle dinside function, so we can avoid handles figures of LR_GUI
plot([0 0], [0 1], 'Color', 'g', 'LineStyle', '-');

hold on, plot(LR_diffSrcSorted, cumPrDiffLRs, 'Color', 'r', 'LineStyle', LINE_STYLE);
hold on, plot(LR_sameSrcSorted, cumPrSameLRs, 'Color', 'b', 'LineStyle', LINE_STYLE);
hold off

title(figure_title)
xlabel('Log Likelihood Ratio')
ylabel('Cumulative Proportion Observed')

legend({'LR = 0', 'Different Source LRs', 'Same Source LRs'})
return

