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

w{1} = fisherc(a_train);
w{2} = nmc(a_train);
kc = 10;
for k = 1 : kc
    w{2+k} = knnc(a_train,k);
end
%w{3+kc} = svc(a_train);
w{3+kc} = perlc(a_train);
%w{4+kc} = bayesc(a_train,[],getlab(trainset));
w{4+kc} = ldc(a_train);
w{5+kc} = qdc(a_train);
pc = 10;
for p = 1 : pc
    w{5+kc+p} = parzenc(a_train,0.05*p);
end
w{6+kc+pc} = treec(a_train,[],0,[]);
w{7+kc+pc} = logmlc(a_train);

c = cell(length(w),1);
for i = 1 : length(w)
    c{i} = getname(w{i});
end

