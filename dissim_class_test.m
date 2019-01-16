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

N = 1000;           % The number of objects taken from the dataset

a = prnist(0:9,1:N);
a = im_resize(a,[20 20]);

% prtime(60) % Increase the maximum time for optimisation

%% Split the dataset in training en test data
n = length(classnames(a));             % The number of classes taken into consideration (default: 10 for classes 0 - 9)
f = 0.8;

seltrain = repmat({1:N*f},1,n); % Building cell vector of entries [1 : N*f(k)]
seltest = repmat({N*f+1:N},1,n);% Building cell vector of entries [N*f(k)+1 : end]
trainset = prdataset(seldat(a,[],[],seltrain)); % Selecting training objects from original dataset
testset = prdataset(seldat(a,[],[],seltest));   % Selecting test objects from original dataset

%% Make the classifiers

[W,E,combc,E2] = make_fdsc(trainset,testset,50,10,4); % Build dissimilarity space classifier, see make_fdsc

[E_min,Id] = min(E); % Find the smallest error of the classifiers
W_opt = W{Id};       % Classifier corrisponding to the smallest error

E_Bestc = nist_eval('my_rep',W_opt); % Re-evauate the best found classifier, this time with nist_eval
E_comb = nist_eval('my_rep',combc);  % Test the combined classifier



