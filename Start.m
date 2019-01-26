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
n = length(classnames(data_im));             % The number of classes taken into consideration (default: 10 for classes 0 - 9)
f = 0.5;
seltrain = repmat({1:N*f},1,n); % Building cell vector of entries [1 : N*f]
seltest = repmat({N*f+1:N},1,n);% Building cell vector of entries [N*f+1 : end]
trainset = (seldat(data_im,[],[],seltrain)); % Selecting training objects from original dataset
testset = (seldat(data_im,[],[],seltest));   % Selecting test objects from original dataset

%% Build multiple Mappings
m = cell(2,1);
m{1} = fisherm(trainset,6);
[m{2},frac] = pcam(trainset,400);
[mm,nm] = size(m);
%% Test multiple classifiers independently
for j = 1 : mm
    [w(:,j),c(:,j)] = BuildClassifiers(false,false,trainset,m{j});
    [mw,nw] = size(w);
    for i = 1 : mw
        E(i,j) = nist_eval('my_rep',m{j}*w{i,j});
    end
end

%% Combine classifiers into one, by minimum combining and voting
for j = 1 : mm
    [W,U] = deal([]);
    for i = 1 : mw
        W = [W m{j}*w{i,j}];
    end
    Wc_median = medianc(W);
    Wc_vote = votec(W);
    Wc_wvote = wvotec(W,ones(mw,1));
    E(mw+1:mw+3,j) = [nist_eval('my_rep',Wc_median) ; ...
        nist_eval('my_rep',Wc_vote) ; nist_eval('my_rep',Wc_wvote)];
end









