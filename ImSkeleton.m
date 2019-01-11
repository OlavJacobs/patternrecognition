clc;
clear all;
close all;
prwaitbar off;

N = 100;
a = prnist(0:9,1:N);
a = im_resize(a,[20 20]);

figure;
show(a)

a_skel = im_skel(prdataset(a));
figure;
show(a_skel);