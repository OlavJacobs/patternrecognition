function [a,W] = apply_kernel_pca(a,N)

scale_map = scalem(a,'variance');
a = a*scale_map;

W = setbatch(kernelm(a,proxm('d',3)));          % proxm('d',1)

W = W(:,1:N);

a = a*W;

W = scale_map*W;

end