%% This scirpt is for test our own written numbers using our classifier

W = combc;

data = [];
labels = [];

for i = 0:9
    for j = 1:10
        s = strcat('HandwrittenDigits/',num2str(i),'_',num2str(j),'.png');
        image = im2bw(rgb2gray(imread(s)),0.1);
        image = im_box(double(image));
        imdata = im_resize(im2obj(image),[20 20]);
        data = [data; imdata];
        labels = [labels; strcat('digit_',num2str(i))];
    end
end

data = setlabels(data,labels);
%%

[E,C] = testc(data,W);

class = labeld(data,W);
class = reshape(class(:,7),[10 10])';

