%% This script is for testing different classifier combiners

% Classifiers are in a cell W

W_ = [];

for i = 1:10
   
    W_ = [W_ W{i}];
    
end

%% Try a bunch of different combiners (untrained

C_v = votec(W_);
C_mean = meanc(W_);
C_med = medianc(W_);
C_max = maxc(W_);
C_min = minc(W_);

% Test the classifiers using nist_eval
E_v = nist_eval('my_rep',C_v);
E_mean = nist_eval('my_rep',C_mean);
E_med = nist_eval('my_rep',C_med);
E_max = nist_eval('my_rep',C_max);
E_min = nist_eval('my_rep',C_min);

%% Trained combiners?