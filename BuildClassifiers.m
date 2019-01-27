function [w,c] = BuildClassifiers(prwait,prwarn,trainset,mapping)
%  This Matlab function builds individual classifiers from supplied data
%  trainset and mapping. If the mapping is not provided, it is equal to one
%  such that classifiers are built with unmapped data. Booleans prwait and
%  prwarn will turn the prwaitbar and prwarnings on or off, respectively. The
%  output to this fuction is cell vector w, containing all trained
%  classifiers, and cell vector c containing all classifier names, such that
%  both can be linked when testing the classifiers.
%
%  Note that the classifiers are selected in compliance to the final report
%  for IN4085 Pattern Recognition, written by Liam Bosland, Olav Jacobs and
%  Simon Stouten

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

w{1,1} = fisherc(a_train);
w{2,1} = nmc(a_train);
kc = 10;
for k = 1 : kc
    w{2+k,1} = knnc(a_train,k);
end
w{3+kc,1} = perlc(a_train);
w{4+kc,1} = ldc(a_train);
w{5+kc,1} = qdc(a_train);
pc = 10;
for p = 1 : pc
    w{5+kc+p,1} = parzenc(a_train,0.05*p);
end
w{6+kc+pc,1} = treec(a_train,[],0,[]);
w{7+kc+pc,1} = logmlc(a_train);

c = cell(length(w),1);
for i = 1 : length(w)
    c{i} = getname(w{i});
end
end