clc
clear all
close all
prwaitbar OFF
a = prnist([0:9],[1:1000]);
a = im_resize(a,[20 20]);

%%
%pixelvalues = +prdataset(a);
%featset = im_features(a,'all');
%labels = getlab(featset');
%featset = +featset;
%show(a)

%% Split the dataset in training en test data

a_train = seldat(a,[],[],{[1:800];[1:800];[1:800];[1:800];[1:800];[1:800];[1:800];[1:800];[1:800];[1:800]});

a_test = seldat(a,[],[],{[801:1000];[801:1000];[801:1000];[801:1000];[801:1000];[801:1000];[801:1000];[801:1000];[801:1000];[801:1000]});

%% Apply demensionality reduction on the training data

% We can fill in different dimensionality reduction methods here

[a_train_pca,pca_map,var_frac] = apply_pca(prdataset(a_train),20);

%% Train classifier

% We can try out different classifiers here

classifier = fisherc(a_train_pca);
%classifier = nmc(a_train_pca);

%% Test the classifier

% Dont forget to also implement the dimensionality reduction mapping if 
% dimensionality reduction was used

a_test = prdataset(a_test);

a_test_pca = a_test * pca_map;

[error,class_f] = testc(a_test_pca*classifier,'crisp');














