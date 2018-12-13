tic;
clc;
clearvars;
close all;
prwarning off;
prwaitbar off;
n = 10;             % The number of classes taken into consideration (default: 10 for classes 0 - 9)
N = 1000;           % The number of objects taken from the dataset

nistdata = prnist((0:(n-1)),1:N);   % Extracting N objects from the NIST-data
nistdata = im_resize(nistdata,20:20,'nearest'); % Resizing the pictures to 20x20 pixels

figure;
for k = 1 : 10
    f(k) = k/10;            % The fraction of training objects taken from the dataset
    
    seltrain = repmat({1:N*f(k)},1,n); % Building cell vector of entries 1:N*f(k)
    seltest = repmat({N*f(k)+1:N},1,n);
    trainset = prdataset(seldat(nistdata,[],[],seltrain)); % Selecting training objects from dataset
    testset = prdataset(seldat(nistdata,[],[],seltest));
    if k == 10
        testset = trainset;
    else
        c(k) = k + 1;
    end
    W = cell(n-1,10);
    for i = 1 : n-1
        m_fisher = fisherm(trainset,i);
        w_fisher = fisherc(trainset*m_fisher);
        W{i,k} = w_fisher;
        [E(i,k),C(:,i)] = testc((testset*m_fisher)*w_fisher,'crisp');
    end
    [E_min(k),n_opt(k)] = min(E(:,k));
    plot(1:(n-1),E(:,k)*100); grid on; hold on;
end
xlabel('Mapped dimensions'); ylabel('Classification Error [%]'); ...
    title('Classification error of Fisher Mapping/Classification');
toc;