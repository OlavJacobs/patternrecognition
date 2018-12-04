function [a,W,frac] = apply_pca(a,N)
% This function takes a dataset a and a number N
%
% Its first output is the new data with N features
% The second output is a mapping from the old to the new data
% The third output is a vector contraining the cumulative fraction of the
% variance that is stored in corrisponding component order.

[W,frac] = klm(a,N);

a = a*W;

end