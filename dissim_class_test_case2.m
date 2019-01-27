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

N = 100;           % The number of objects taken from the dataset per class

a = prnist(0:9,1:N);
a = im_resize(a,[20 20]);

% prtime(60) % Increase the maximum time for optimisation

%% Split the dataset in training en test data
n = length(classnames(a));             % The number of classes taken into consideration (default: 10 for classes 0 - 9)

E_NIST = 0;         % Initalize the error sum

for i = 0:9

seltrain = repmat({1+10*i:10+10*i},1,n); % Building cell vector of entries [1 : N*f(k)]
seltest = repmat({1:N},1,n);% Building cell vector of entries [N*f(k)+1 : end]
trainset = prdataset(seldat(a,[],[],seltrain)); % Selecting training objects from original dataset
testset = prdataset(seldat(a,[],[],seltest));   % Selecting test objects from original dataset

%% Make the classifiers

[W,~,Wcomb] = make_fdsc_case2(trainset,testset,10,1,1); % Build dissimilarity space classifier, see make_fdsc_case2

E_NIST = E_NIST + nist_eval('my_rep',W{1}); % Sum all the errors calculated with nist eval


end

E_NIST = E_NIST/10;