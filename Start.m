tic;
clc
clearvars
close all
prwaitbar ON
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


%% Test multiple classifiers independently
for j = 1 : size(m,1)
    [w(:,j),c(:,j)] = BuildClassifiers(false,false,trainset,m{j});
    for i = 1 : size(w(:,j),1)
        E(i,j) = nist_eval('my_rep',m{j}*w{i,j});
    end
end

%% Test all classifiers combined, using voting
W = [];
for i = 1 : size(w(:,1),1)
    W = [W ; w{i,1}];
end
Wcombined = wvotec(trainset,W);
for j = 1 : size(m,1)
    E_combined(j) = nist_eval('my_rep',(repmat(m{j},size(w(:,j),1))).*W);
end
%%
%pixelvalues = +prdataset(a);
%featset = im_features(a,'all');
%labels = getlab(featset');
%featset = +featset;
%show(a)


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

%% Applying Fisher mapping and Fisher linear classification to the given images

figure;
f = [0.25,0.5,0.75,0.85];   % The fraction of training objects taken from the dataset
Leg = cell(4,1);
for k = 1 : 4
    seltrain = repmat({1:N*f(k)},1,n); % Building cell vector of entries [1 : N*f(k)]
    seltest = repmat({N*f(k)+1:N},1,n);% Building cell vector of entries [N*f(k)+1 : end]
    trainset = prdataset(seldat(a,[],[],seltrain)); % Selecting training objects from original dataset
    testset = prdataset(seldat(a,[],[],seltest));   % Selecting test objects from original dataset
    W = cell(n-1,length(f));              % Define a cell matrix as classifier storage
    % Looping over all possible dimensions to map, defined for the Fisher
    % mapping (defined as input N to fisherm), to find an optimal amount of
    % dimensions to map to, minimizing the classification error for
    % selected test- and trainingsets
    for i = 1 : n-1
        % The function fisherm constructs a mapping, such that trainset is
        % mapped to i (up to a maximum of n-1) dimensions.
        m_fisher = fisherm(trainset,i);
        % Fisherc constructs a classifier on the the mapped training set
        w_fisher = fisherc(trainset*m_fisher);
        W{i,k} = w_fisher;  % The constructed classifier is stored in the cell matrix W
        % Using testc the classifier is tested, with outputs error E and
        % the number of erroneously classified objects per class C. The
        % type of testing is set to crisp, since the data is
        [E(i,k),C(:,i)] = testc(testset,m_fisher*w_fisher,'crisp');
    end
    [E_min(k),n_opt(k)] = min(E(:,k));
    plot(1:(n-1),E(:,k)*100); grid on; hold on;
    Leg{k} = strcat('f(k) = ',num2str(f(k)));
end
legend(Leg);
xlabel('Mapped dimensions'); ylabel('Classification Error [%]'); ...
    title('Classification error of Fisher Mapping/Classification');
toc;













