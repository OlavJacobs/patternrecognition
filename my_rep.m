function [a] = my_rep(m)
% This function acts as a dataset-loader for the nist_eval function, which
% is being called multiple times during classifier testing. The input to
% this function is NIST image data m, which is resized and converted into a
% dataset, such that output a presents the dataset of the NIST images.
m = im_resize(m,[20 20]);
a = prdataset(m);
end