function [W,E,combc,E2] = make_fdsc(a_train,a_test,N,M)
% Make a dissimilarity space classifier. This function will make an N
% dimensional dissimilarity space classifier. If M is more than 1, it will
% make M classifiers, and combine them in combc. E2 is the error rate of
% the combinde classifier

% Select data for representation
W = [];

%Select data M times
for i = 1:M
    r = gendat(a_train,ones(1,10)*N);
    c = setbatch(fdsc(a_train,r,[],[],4,[]));
    E(i) = testc(a_test,c);
    W = [W c];
end

%Combine the clasifiers
combc = votec(W);

E2 = testc(a_test,combc);

end
