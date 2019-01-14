%% combine classfiers.m
% Make a dissimilarity space classifier and a kernelm + fisherc classifier
% to see if combining the 2 classifier will improve the overal preformacne
% of the classifier (bring down the error)

%% Initialize

clc
clearvars
close all
prwaitbar OFF
prwarning OFF

N = 1000;           % The number of objects taken from the dataset

a = prnist(0:9,1:N);
a = im_resize(a,[20 20]);

%% Split the dataset in training en test data
n = length(classnames(a));             % The number of classes taken into consideration (default: 10 for classes 0 - 9)
f = 0.8;
seltrain1 = repmat({1:N*f},1,n); % Building cell vector of entries [1 : N*f(k)]
%seltrain2 = repmat({N*f+1:2*N*f},1,n);
seltest = repmat({N*f+1:N},1,n);% Building cell vector of entries [N*f(k)+1 : end]
trainset1 = prdataset(seldat(a,[],[],seltrain1)); % Selecting training objects from original dataset
%trainset2 = prdataset(seldat(a,[],[],seltrain2));
testset = prdataset(seldat(a,[],[],seltest));   % Selecting test objects from original dataset

%% Build a pca + fisherc classifier

[~,W_pca] = apply_pca(trainset1,50);

classifier_f1 = fisherc(trainset1*W_pca);

[E_fisherc1,F1] = testc(testset,W_pca*classifier_f1);

%% Builde a kernelm + fisherc classifier

[~,W_kpca] = apply_kernel_pca(trainset1,50);

classifier_f2 = fisherc(trainset1*W_kpca);

[E_fisherc2,F2] = testc(testset,W_kpca*classifier_f2);

%% Build dissimilarity space classifier

[classifier_ds,E_ds] = make_fdsc(trainset1,testset,50,1);

%% Combine the 2 classifiers

classifier_comb = minc([classifier_ds, W_kpca*classifier_f2]);

E_comb = testc(testset,classifier_comb);


