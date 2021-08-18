%% Fitted Model hospital data
clc;clear;rehash;
% Add the function to path
addpath(genpath('C:\Users\gabri\Dropbox\sem2_2020\honours\code\vspglm\src'))
%%
X = readtable("hospital.csv");
X.month = X.month;
firstQuarter = ones(height(X), 1);
threeQuarters = zeros(height(X), 1);
X = [X, table(firstQuarter, threeQuarters)];

%% Hospital Histogram 
close all;
fig = figure('units','normalized','outerposition',[0 0 1 1]);

subplot(2,2,1)
histogram(X.v1, 'BinMethod','integer')
xlim([-0.5, 8])
ylim([0, 60])
title('January-March','fontsize', 20)
subplot(2,2,2)
histogram(X.v2, 'BinMethod','integer')
xlim([-0.5, 8])
ylim([0, 60])
title('April-June','fontsize', 20)
subplot(2,2,3)
histogram(X.v3, 'BinMethod','integer')
xlim([-0.5, 8])
ylim([0, 60])
title('July-September','fontsize', 20)
subplot(2,2,4)
histogram(X.v4, 'BinMethod','integer')
xlim([-0.5, 8])
ylim([0, 60])
title('October-December','fontsize', 20)

han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Hospital Visits','fontsize', 20);
print('hospital_hist.png', '-dpng')
%% Hospital QQ plots
pd1 = fitdist(X.v1, 'poisson');
pd2 = fitdist(X.v2, 'poisson');
pd3 = fitdist(X.v3, 'poisson');
pd4 = fitdist(X.v4, 'poisson');
%%
close all;
fig = figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,2,1)
qqplot(X.v1, pd1)
grid on 
ax = gca;
title(ax, 'January - March', 'fontsize',15)
xlabel(ax, '')
ylabel(ax, '')
subplot(2,2,2)
qqplot(X.v2, pd2)
grid on 
ax = gca;
title(ax, 'April - June', 'fontsize',15)
xlabel(ax, '')
ylabel(ax, '')
subplot(2,2,3)
qqplot(X.v3, pd3)
grid on 
ax = gca;
title(ax, 'July - September', 'fontsize',15)
xlabel(ax, '')
ylabel(ax, '')
subplot(2,2,4)
qqplot(X.v4, pd4)
grid on 
ax = gca;
title(ax, 'October - December', 'fontsize',15)
xlabel(ax, '')
ylabel(ax, '')
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Sample Quantiles','fontsize',15);
xlabel(han,'Theoretical Quantiles','fontsize', 15);
print('hospital_qq.png', '-dpng')

%%
links = {'log', 'log', 'log', 'log'};
model = fit_vspglm(["(v1, v2, v3, v4) ~ ((firstQuarter&0&0&0), month,smoking)"], X,  links);
model.coefficients
%save('hospital', 'model')
