function [a,W,frac] = apply_pca(a,N)
% This function takes a dataset a and a number N
%
% Its first output is the new data with N features
% The second output is a mapping from the old to the new data
% The third output is a vector contraining the cumulative fraction of the
% variance that is stored in corrisponding component order.

% First we scale the training data to normalize the variance
scale_map = scalem(a,'variance');
a = a*scale_map;

% Calculate the pca mapping
[W,frac] = pcam(a,N);

% We can also use klm to look at class 
% covariance instead of the overal 
% covariance

a = a*W;

% Remake the overal mapping to include the scaling
W = scale_map*W;

end