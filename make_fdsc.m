function [W,E,combc,E2] = make_fdsc(a_train,a_test,N,M)

% Select data for representation
W = [];

for i = 1:M
    r = gendat(a_train,ones(1,10)*N);
    c = fdsc(a_train,r,[],[],[],[]);
    E(i) = testc(a_test,c);
    W = [W c];
end

combc = wvotec(a_train,W);
%combc = averagec(W);
E2 = testc(a_test,combc);

end
