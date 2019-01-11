function [] = Classifiers(trainset,testset,mapping)
if nargin == 2 % Two inputs supplied, thus mapping = [] and no mapping is used
    mapping = 1;
end
a_train = trainset*mapping;
a_test = testset*mapping;
w = cell(12,1);
c = cell(length(w),1);
w{1} = fisherc(a_train,6);
w{2} = logmlc(a_train);
w{3} = nmc(a_train);
w{4} = qdc(a_train);
w{5} = pca(a_train);
[w{6},K,E] = knnc(a_train,5);
[w{7},V,ALF] = adaboost(a_train,weakc);
[w{8},H] = parzenc(a_train,H);
w{9} = treec(a_train,INFCRIT,0,[]);
w{10} = naivebc(a_train);
w{11} = perlc(a_train); 
w{12} = svc(a_train);

for i = 1 : length(w)
    c{i} = getname(w{i});
end

