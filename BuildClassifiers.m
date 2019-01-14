function [w,c] = BuildClassifiers(prwait,prwarn,trainset,mapping)
if nargin == 3 % Two inputs supplied, thus mapping = [] and no mapping is used
    mapping = 1;
end
if prwait == false
    prwaitbar OFF
end
if prwarn == false
    prwarning(0)
end
a_train = trainset*mapping;
w = cell(9,1);
c = cell(length(w),1);

w{1} = fisherc(a_train);
w{2} = logmlc(a_train);
w{3} = nmc(a_train);
w{4} = qdc(a_train);
[w{5},K,E] = knnc(a_train,5);
%[w{6},V,ALF] = adaboostc(a_train,weakc);
[w{6},H] = parzenc(a_train,0.01);
w{7} = treec(a_train,[],0,[]);
w{8} = ldc(a_train);
w{9} = perlc(a_train); 
%w{10} = svc(a_train);

for i = 1 : length(w)
    c{i} = getname(w{i});
end

