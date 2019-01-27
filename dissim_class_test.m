%% Make multiple dissimilarity space classifiers
% Make multiple fdsc classifiers. Since data is randomly selected for 
% dissimilarity mapping, every classifier will be slightly different. We
% can than eather select the classifier with the lowest error or we combine
% the classifiers for a slower classifiers, but a slightly better error %

%% Initialize

clc
clearvars
close all
prwaitbar OFF
prwarning OFF

N = 1000;           % The number of objects taken from the dataset per class

a = prnist(0:9,1:N);        % Take N objects per class from the NIST dataset
a = im_resize(a,[20 20]);   % Resize the images so they are equal size 20 X 20

% prtime(300) % Increase the maximum time for optimisation is nessesary

%% Split the dataset in training en test data
n = length(classnames(a));             % The number of classes taken into consideration (default: 10 for classes 0 - 9)
f = 0.8;

seltrain = repmat({1:N*f},1,n); % Building cell vector of entries [1 : N*f(k)]
seltest = repmat({N*f+1:N},1,n);% Building cell vector of entries [N*f(k)+1 : end]
trainset = prdataset(seldat(a,[],[],seltrain)); % Selecting training objects from original dataset
testset = prdataset(seldat(a,[],[],seltest));   % Selecting test objects from original dataset

%% Make the classifiers

[W,E,combc,E2] = make_fdsc(trainset,testset,5,10,2); % Build dissimilarity space classifier, see make_fdsc

[E_min,Id] = min(E); % Find the smallest error of the classifiers
W_opt = W{Id};       % Classifier corrisponding to the smallest error

E_Bestc = nist_eval('my_rep',W_opt); % Re-evauate the best found classifier, this time with nist_eval
E_comb = nist_eval('my_rep',combc);  % Test the combined classifier

%% This script is for testing different classifier combiners
%{
% Classifiers are in a cell W

W_ = [];

[~,I] = sort(E);
W = W(I);               % Sort the classifiers from best preforming to worst

for i = 1:3
       W_ = [W_ W{i}];  % Append the classifiers
end
%}
%% Try a bunch of different combiners (untrained
%{
tic;

% Here we test a bunch of combiners for a different number of classifiers
% (1:20)
for i = 1:20
C_v = votec(W_(:,1:(10+((i-1)*10))));
C_mean = meanc(W_(:,1:(10+((i-1)*10))));
C_med = medianc(W_(:,1:(10+((i-1)*10))));
C_max = maxc(W_(:,1:(10+((i-1)*10))));
C_min = minc(W_(:,1:(10+((i-1)*10))));

% Test the classifiers using nist_eval
E_v(i) = nist_eval('my_rep',C_v);
E_mean(i) = nist_eval('my_rep',C_mean);
E_med(i) = nist_eval('my_rep',C_med);
E_max(i) = nist_eval('my_rep',C_max);
E_min(i) = nist_eval('my_rep',C_min);
end
toc

%% Make a plot
x = 1:20;
figure
plot(x,E_v,'-o',x,E_max,'-*',x,E_mean,'-s',x,E_med,'-d',x,E_min,'-x')
legend('Voted', 'Max','Mean', 'Med','Min','Location','southeast')
axis([1 20 0 0.04])
xlabel('Number of classifiers combined')
ylabel('Classification error')
%}
