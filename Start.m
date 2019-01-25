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
f = 0.8;
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
        E(i,j) = nist_eval('my_rep',m{j}*w{i,j},100);
    end
    % Find the lowest error per mapping
    [Emin(1,j),Imin(1,j)] = min(E(:,j));
    cmin(1,j) = c(Imin(j),j);
end

%% Combine classifiers into one, by minimum combining and voting
for j = 1 : mm
    [W,U] = deal([]);
    for i = 1 : mw
        W = [W m{j}*w{i,j}];
    end
    Wc_median = medianc(W);
    Wc_vote = votec(W);
    E(mw+1:mw+2,j) = [nist_eval('my_rep',Wc_median) ; ...
        nist_eval('my_rep',Wc_vote)];
end

%% Apply demensionality reduction on the training data

% We can fill in different dimensionality reduction methods here

%[a_train_pca,pca_map,var_frac] = apply_pca(prdataset(a_train),20);

[a_train_kpca,W_train_kpca] = apply_kernel_pca(a_train,20);

%% Train classifier

% We can try out different classifiers here

a_train_kpca = prdataset(a_train_kpca);

classifier = fisherc(a_train_kpca);
%classifier = nmc(a_train_kpca);

%% Test the classifier

% Dont forget to also implement the dimensionality reduction mapping if
% dimensionality reduction was used

a_test = prdataset(a_test);

a_test_pca = a_test * pca_map;

[error,class_f] = testc(a_test_pca*classifier,'crisp');

toc;













