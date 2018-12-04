clc
clear all
close all
prwaitbar OFF
a = prnist([0:4],[1:40:40]);
a = im_resize(a,[40 40]);
pixelvalues = +prdataset(a);
featset = im_features(a,'all')
labels = getlab(featset')
featset = +featset
show(a)
