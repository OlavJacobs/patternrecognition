% This Matlab script has been written to test the mappings, using the
% function BuildClassifiers.m, and returning the errors performances. 
% This script has been written in compliance to the final report of IN4085 
% Pattern Recognition, written by Liam Bosland, Olav Jacobs and Simon Stouten

clc
clearvars
close all
prwaitbar OFF
prwarning OFF

starttotal = tic;
N = 1000;           % The number of objects taken from the dataset

imfile = prnist(0:9,1:N);
data_im = my_rep(imfile);

% In order to obtain insight on parameter performance of the mappings, they
% are being tested using for-loops. Both the fraction of data f and the
% dimensions for the mappings (dfish, dpca) are being looped, thus this
% script may take a while to complete.
% Test 1 : f = [0.25 0.5 0.75], dfish = [1 ... 9], dpca = [40 ... 360]
% Test 2 : f = [0.65 0.75 0.85], dfish = [4 5 6 7 8] dpca = [240 260 280 300 320]
% Test 3 : f = 0.8, dfish = [6 7 8], dpca = [220 240 260]
% Test 4 : f = 0.8, dfish = [5 6 7], dpca = [180 200 220]
% Test 5 : f = 0.8, dfish = [5 6 7], dpca = [100 140 180]
% Test 6 : f = 0.8, dfish = [5 6 7], dpca = [20 60 100]
% Test 7 : f = 0.8, dfish = [5 6 7], dpca = [5 10 15]
dfish = [5 6 7]; dpca = [5 10 15];
f = 0.8;
count = 0;  % a counting placeholder
[Error_fisher,Error_pca] = deal(cell(length(f),length(dfish)));
for k = 1 : length(f)
    %% Split the dataset in training en test data
    n = length(classnames(data_im));             % The number of classes taken into consideration (default: 10 for classes 0 - 9)
    frac = round(f(k),1);
    seltrain = repmat({1:N*frac},1,n); % Building cell vector of entries [1 : N*f]
    seltest = repmat({N*frac+1:N},1,n);% Building cell vector of entries [N*f+1 : end]
    trainset = (seldat(data_im,[],[],seltrain)); % Selecting training objects from original dataset
    testset = (seldat(data_im,[],[],seltest));   % Selecting test objects from original dataset
    for p = 1 : length(dfish)
        count = count + 1;
        maptime = tic; % A timer for individual mapping computation times
        %% Build Mappings
        % These mappings are the Fisher mapping and Principal Component Analysis
        m = cell(2,1);
        m{1} = fisherm(trainset,dfish(p));
        [m{2},~] = pcam(trainset,dpca(p));
        [mm,nm] = size(m);
        %% Test multiple classifiers independently
        % Tested using the nist_eval function, returning misclassification error E
        for j = 1 : mm
            [w(:,j),c] = BuildClassifiers(false,false,trainset,m{j});
            [mw,nw] = size(w);
            for i = 1 : mw
                E(i,j) = nist_eval('my_rep',m{j}*w{i,j});
            end
        end
        tmap = toc(maptime);
        Error_fisher{k,p} = E(:,1); Error_pca{k,p} = E(:,2);
        clear E w c m;
        perc = round(count*(100/(length(f)*length(dfish))),0);
        fprintf('Progress: %i%% | Time taken: %f seconds',perc,tmap);
        fprintf('\n');
    end
    
end
ttotal = toc(starttotal);