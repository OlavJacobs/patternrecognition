function [W,E,combc,E2] = make_fdsc(a_train,a_test,N,M,P)
% Make a dissimilarity space classifier. This function will make an N
% dimensional dissimilarity space classifier. If M is more than 1, it will
% make M classifiers, and combine them in combc using a vote combiner. E2 
% is the error rate of the combinde classifier. P is the order of the 
% (distance) proximity mapping used.

W_ = [];

%Select data M times
for i = 1:M
    r = gendat(a_train,ones(1,10)*N); % Choose a random reference set from the training data
    
    c = setbatch(fdsc(a_train,r,[],[],P,[])); % Make an classifier using fdsc, setbatch is used so 
                                              % that the script doesnt overload for large values of N
                                              
    E(i) = testc(a_test,c); % Calculate the error of the classifier
    W_ = [W_ c];    % Appaned the classifiers
    W{i} = c;       % Make a cell with the classifiers
end

combc = minc(W_); %Combine the clasifiers with votec


E2 = testc(a_test,combc); % Test the combined classifier

end
