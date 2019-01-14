%% Make multiple dissimilarity space classifiers
% Make multiple classifiers, since date is randomly selected for kernel
% pca. We can than make multiple classifiers

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
seltrain1 = repmat({1:N*f},1,n); % Building cell vector of entries [1 : N*f(k)]
%seltrain2 = repmat({N*f+1:2*N*f},1,n);
seltest = repmat({N*f+1:N},1,n);% Building cell vector of entries [N*f(k)+1 : end]
trainset1 = prdataset(seldat(a,[],[],seltrain1)); % Selecting training objects from original dataset
%trainset2 = prdataset(seldat(a,[],[],seltrain2));
testset = prdataset(seldat(a,[],[],seltest));   % Selecting test objects from original dataset

%%

[W,E,combc,E2] = make_fdsc(trainset1,testset,50,10);

E_min = min(E);

%E_nist = nist_eval(testset



