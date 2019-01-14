function [a] = my_rep(m)
m = im_resize(m,[20 20]);
a = prdataset(m);
end

