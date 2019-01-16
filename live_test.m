%% This scirpt is for test our own written numbers using our classifier
data = [];

for i = 0:9
    for j = 1:10
        s = strcat('HandwrittenDigits/',num2str(i),'_',num2str(j),'.png');
        image = im2bw(rgb2gray(imread(s)),0.1);
        imdata = im_resize(im2obj(image),[20 20])
        data = [data; imdata];
    end
end