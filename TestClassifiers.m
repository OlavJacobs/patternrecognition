% This Matlab script has been written to test individual classifiers, given
% by the function BuildClassifiers.m, and returning the errors. This script
% has been written in compliance to the final report of IN4085 Pattern
% Recognition, written by Liam Bosland, Olav Jacobs and Simon Stouten

tic;
clc
clearvars
close all
prwaitbar OFF
prwarning OFF

N = 1000;           % The number of objects taken from the dataset

imfile = prnist(0:9,1:N);
data_im = my_rep(imfile);
%% Split the dataset in training en test data
% As a default, 0.8 of data is used for training
n = length(classnames(data_im));             % The number of classes taken into consideration (default: 10 for classes 0 - 9)
f = 0.8;
seltrain = repmat({1:N*f},1,n); % Building cell vector of entries [1 : N*f]
seltest = repmat({N*f+1:N},1,n);% Building cell vector of entries [N*f+1 : end]
trainset = (seldat(data_im,[],[],seltrain)); % Selecting training objects from original dataset
testset = (seldat(data_im,[],[],seltest));   % Selecting test objects from original dataset

%% Build Mappings
% These mappings are the Fisher mapping and Principal Component Analysis
m = cell(2,1);
m{1} = fisherm(trainset,7);
[m{2},frac] = pcam(trainset,15);
[mm,nm] = size(m);
%% Test multiple classifiers independently
% Tested using the nist_eval function, returning misclassification error E
for j = 1 : mm
    [w(:,j),c(:,j)] = BuildClassifiers(false,false,trainset,m{j});
    [mw,nw] = size(w);
    for i = 1 : mw
        E(i,j) = nist_eval('my_rep',m{j}*w{i,j});
    end
end

%% Combine individual classifiers into one, by median and vote combining
% Note that this is not used in the final report, different combiners were
% used.
for j = 1 : mm
    W = [];
    for i = 1 : mw
        W = [W m{j}*w{i,j}];
    end
    Wc_median = medianc(W);
    Wc_vote = votec(W);
    E(mw+1:mw+2,j) = [nist_eval('my_rep',Wc_median) ; ...
        nist_eval('my_rep',Wc_vote)];
end
% The final two rows of matrix E are the combiner errors, for the
% performance of the individual classifiers the reader is referred to the
% matrix E(1:end-2,:)