function [a,W] = apply_kernel_pca(a,N)
% This paper contains an example for kernel mapping with dissimilarity for
% the NIST dataset
% http://rduin.nl/papers/pr_06_protosel.pdf

scale_map = scalem(a,'variance');
a = a*scale_map;

m = knnm(1);

W = kernelm(a,m,'random',N);

%W = setbatch(kernelm(a,proxm('d',3)));          % proxm('d',1)
% setbatch allows for batch calculation, this is nessesary because
% otherwise matlab wil run out of memory (check later if it can be removed)

%W = W(:,1:N);

a = a*W;

W = scale_map*W;

end